namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Win = (int, vec<int>); 

final class Day22 {
    use UtilsTrait;

    public $ingredient_allergens = dict<string, keyset<string>>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
Player 1:
9
2
6
3
1

Player 2:
5
8
4
7
10
EOD;
$sample2 = <<<EOD
Player 1:
43
19

Player 2:
2
29
14
EOD;
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
        $deck1 = vec[];
        $deck2 = vec[];
        $pos1 = 0;
        $pos2 = 0;
        $cur = 1;
        foreach($lines as $line) {
            if ($line === ''){
                $cur = 2;
                continue;
            }
            if ($line[0] != 'P') {
                switch($cur){
                    case 1:
                        $deck1[] = Str\to_int($line);
                        break;
                    case 2:
                        $deck2[] = Str\to_int($line);
                        break;
                }
            }
        }
        $winner = $this->play($deck1, $deck2);
        $deck = $winner[1];
        $check_deck = $winner[0] === 1 ? $deck1 : $deck2;

        $mult = C\count($deck);
        for($i = 0; $i < C\count($deck); $i++) {
            print($deck[$i].", ");
            $count += ($mult * $deck[$i]);
            $mult--;
        }
        print("\n");
            
        return "".$count;
    }

    public function play(vec<int> $deck1, vec<int> $deck2) : Win {
        $seen = keyset<string>[];
        
        while(C\count($deck1)>0 && C\count($deck2)>0) {
            $pattern = $this->buildPattern($deck1, $deck2);
            if (C\contains_key($seen, $pattern)) {
                return tuple(1, $deck1);
            }
            //print($pattern."\n");
            $seen[] = $pattern;
            //print(C\count($seen)."\n");
            $card1 = $deck1[0];
            $card2 = $deck2[0];

            if (C\count($deck1) > $card1 && C\count($deck2) > $card2) {
                $winner = $this->play(Vec\slice($deck1, 1, $card1), Vec\slice($deck2, 1, $card2))[0];
            } else {
                $winner = $card1 > $card2 ? 1 : 2;
            }
            if ($winner === 1) {
                $deck1[] = $card1;
                $deck1[] = $card2;
            } else {
                $deck2[] = $card2;
                $deck2[] = $card1;
            }
            $deck1 = Vec\slice($deck1, 1);
            $deck2 = Vec\slice($deck2, 1);
        }

        return C\count($deck1)>C\count($deck2) ? tuple(1, $deck1) : tuple(2, $deck2);
    }

    public function buildPattern(vec<int> $deck1, vec<int> $deck2) : string {
        $result = '';
        foreach($deck1 as $c){
            $result = $result.' '.$c;
        }
        $result = $result.'|';
        foreach($deck2 as $c) {
            $result = $result.' '.$c;
        }
        return $result;
    }
}
