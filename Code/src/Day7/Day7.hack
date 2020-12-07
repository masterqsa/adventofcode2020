namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Rule = (int, string);

final class Day7 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.
EOD;
$sample2 = null;
$sample3 = null;
        static::runSamplesAndActual(
            vec[$sample1, $sample2, $sample3],
            $s,
            inst_meth($this, 'doCase'),
        );
    }

    public function doCase(
        string $input,
    ): string {
        $lines = Str\split($input, "\n");

        $count = 0;
        $reverse = dict<string, vec<string>>[];
        $rules = dict<string,vec<Rule>>[];
        $result = keyset[];
        $goal = "shiny gold";
        foreach($lines as $line) {
            //print($line."\n");
            $matches = Regex\every_match($line, re"/([a-z\s]+) bags contain ([a-z0-9\s,.]+)\./");
            Vec\flatten($matches);
            // print($matches[0][1]." - ");
            // print($matches[0][2]."\n");
            $bagtype = $matches[0][1];
            if ($matches[0][2] === "no other bags") {
                $rules[$bagtype] = vec[];
            } else {
                $matches = Str\split($matches[0][2], ", ");
                $rule = vec<Rule>[];
                foreach($matches as $match){
                    //print($match."\n");
                    $parts = Str\split($match, " ");
                    $childbag = $parts[1]." ".$parts[2];
                    $rule[] = tuple(Str\to_int($parts[0]), $childbag);
                    if(C\contains_key($reverse, $childbag)) {
                        //print("add reverse for ".$childbag."\n");
                        $reverse[$childbag][] = $bagtype;
                    } else {
                        //print("create reverse for ".$childbag."\n");
                        $reverse[$childbag] = vec[$bagtype];
                    }
                    //print($childbag."<--".$bagtype."\n");
                }
                $rules[$bagtype] = $rule;
                //print($bagtype." - ".C\count($rule)."\n");
            }
        }

        print("reverse: ".C\count($reverse)."\n");
        print("reverse shiny gold: ".C\count($reverse[$goal])."\n");
        print("reverse shiny gold: ".$reverse[$goal][0]."\n");
        $queue = vec[$goal];
        $visited = keyset[];
        $index = 0;
        $first = true;
        //Part 1
        // while($index < C\count($queue)) {
        //     $current = $queue[$index];
        //     print($current."\n");
        //     $index++;
        //     if(!C\contains($visited, $current) && !$first) {
        //         $visited[]=$current;
        //     }
        //     if(C\contains_key($reverse, $current)) {
        //         foreach($reverse[$current] as $bagtype) {
        //             if(!C\contains($visited, $bagtype)) {
        //                 $queue[] = $bagtype;
        //             }
        //         }
        //     }
        //     $first = false;
        // }
        // $count = C\count($visited);

        //Part 2
        $count = static::calcBags($rules, $goal) - 1;

        
        return "".$count;
    }

    public static function calcBags(dict<string,vec<Rule>> $rules, string $bagtype): int {
        $count = 1;
        if (C\contains_key($rules, $bagtype)) {
            foreach($rules[$bagtype] as $rule) {
                $count += $rule[0] * static::calcBags($rules, $rule[1]);
            }
        }
        return $count;
    }

    
}
