namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Match = (string, string); 

final class Day21 {
    use UtilsTrait;

    public $ingredient_allergens = dict<string, keyset<string>>[];
    public $ingredients = dict<string, int>[];
    public $allergens = keyset<string>[];
    public $allergens_ingred = dict<string, keyset<string>>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
mxmxvkd kfcds sqjhc nhms (contains dairy, fish)
trh fvjkl sbzzf mxmxvkd (contains dairy)
sqjhc fvjkl (contains soy)
sqjhc mxmxvkd sbzzf (contains fish)
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
        $this->ingredient_allergens = dict<string, keyset<string>>[];
        $this->ingredients = dict<string, int>[];
        $this->allergens = keyset<string>[];
        $this->allergens_ingred = dict<string, keyset<string>>[];
        $lines = Str\split($input, "\n");
        $count = 0;
        foreach($lines as $line) {
            $parts = Str\split($line, ' (contains ');
            $ingredients = Str\split($parts[0], ' ');
            $allergens = Str\split(Str\replace($parts[1], ')', ''), ', ');

            $this->allergens = Keyset\union($this->allergens, $allergens);

            foreach($ingredients as $ing){
                if (!C\contains_key($this->ingredients, $ing)) {
                    $this->ingredients[$ing] = 1;
                } else {
                    $this->ingredients[$ing]+=1;
                }

                if (!C\contains_key($this->ingredient_allergens, $ing)) {
                    $this->ingredient_allergens[$ing] = keyset($allergens);
                } else {
                    $this->ingredient_allergens[$ing] = Keyset\union($this->ingredient_allergens[$ing], $allergens);
                }
            }
            foreach($allergens as $alg) {
                if (!C\contains_key($this->allergens_ingred, $alg)) {
                    $this->allergens_ingred[$alg] = keyset($ingredients);
                } else {
                    $this->allergens_ingred[$alg] = Keyset\intersect($this->allergens_ingred[$alg], $ingredients);
                }
            }
        }

        $used = keyset[];
        $done = keyset[];
        $match = vec<Match>[];
        for($x = 0; $x < C\count($this->allergens); $x++){
            foreach($this->allergens as $alg) {
                if (!C\contains_key($done, $alg)) {
                    if (C\count($this->allergens_ingred[$alg]) === 1) {
                        $ing = vec($this->allergens_ingred[$alg])[0];
                        $done[] = $alg;
                        $used[] = $ing;
                        print($alg." == ".$ing."\n");
                        $match[] = tuple($alg, $ing);
                        break;
                    }
                }
            }
            foreach($this->allergens_ingred as $a => $i) {
                if (!C\contains_key($done, $a)) {
                    $this->allergens_ingred[$a] = Keyset\diff($this->allergens_ingred[$a], $used);
                }
            }
        }

        foreach($this->ingredients as $ing => $c) {
            if (!C\contains_key($used, $ing)) {
                print("non-used: ".$ing."\n");
                $count += $c;
            }
        }

        $result = '';
        foreach(Vec\sort($match) as $m){
            print($m[0].",");
            $result = $result.",".$m[1];
        }
        print("\n");
        print($result."\n");
            
        return "".$count;
    }

    

}
