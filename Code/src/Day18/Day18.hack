namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype Cell = (int, int);

final class Day18 {
    use UtilsTrait;

    public $map = dict<string, Cell>[];
    public $odd = true;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
1 + 2 * 3 + 4 * 5 + 6
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
        $this->map = dict<string, Cell>[];
        $lines = Str\split($input, "\n");
        $sum = 0;
        $count = 0;
        foreach($lines as $line) {
            $count++;
            $line = Str\replace($line, ' ', '');
            //print($line." => ");

            //part 2: set brackets to ensure order of operations, then reuse part 1
            $line = $this->addBrackets($line);
            //print($line."\n");
            $sum += $this->calcExpression($line);
        }

        print("sum = ".$sum."\n");
        
        return "".$count;
    }

    public function addBrackets(string $line): string {
        $pluses = C\count(Str\split($line, '+')) - 1;
        for($step = 0; $step < $pluses; $step++) {
            $pos = Str\search($line, '+');
            $leftpart = Str\slice($line,0,$pos);
            $rightpart = Str\slice($line,$pos+1);
            print($leftpart." / ".$rightpart."\n");
            $line = $this->findPosLeft($leftpart).'-'.$this->findPosRight($rightpart);
        }
        return Str\replace($line, '-', '+');
    }
    public function findPosLeft(string $s): string {
        $brackets = 0;
        for($i = Str\length($s)-1; $i >= 0; $i--) {
            switch($s[$i]) {
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                    if ($brackets === 0) {
                        return ($i > 0 ? Str\slice($s, 0, $i) : '').'('.Str\slice($s, $i);
                    }
                    break;
                case '-':
                case '*':
                case '+':
                    break;
                case ')':
                    $brackets++;
                    break;
                case '(':
                    $brackets--;
                    if ($brackets === 0) {
                        return ($i > 0 ? Str\slice($s, 0, $i) : '').'('.Str\slice($s, $i);
                    }
                    break;
            }
        }
        return $s;
    }
    public function findPosRight(string $s): string {
        $brackets = 0;
        for($i = 0; $i < Str\length($s); $i++) {
            switch($s[$i]) {
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                    if ($brackets === 0) {
                        return ($i >= 0 ? Str\slice($s, 0, $i+1) : '').')'.($i <= (Str\length($s)-1) ? Str\slice($s, $i + 1) : '');
                    }
                    break;
                case '-':
                case '*':
                case '+':
                    break;
                case '(':
                    $brackets++;
                    break;
                case ')':
                    $brackets--;
                    if ($brackets === 0) {
                        return Str\slice($s, 0, $i+1).')'.($i <= (Str\length($s)-1) ? Str\slice($s, $i + 1): '');
                    }
                    break;
            }
        }
        return $s;
    }

    public function calcExpression(string $line): int {
        $operands = dict<string, int>[];
        $operands[0] = 0;
        $operations = dict<string, string>[];
        $operations[0] = '';
        $brackets = 0;
        for($i=0; $i<Str\length($line); $i++) {
            $num = 0;
            // part 1
            switch($line[$i]) {
                case '1':
                case '2':
                case '3':
                case '4':
                case '5':
                case '6':
                case '7':
                case '8':
                case '9':
                    $num = Str\to_int($line[$i]);
                    switch($operations[$brackets]) {
                        case '':
                            $operands[$brackets] = $num;
                            break;
                        case '*':
                            $operands[$brackets] = $operands[$brackets] * $num;
                            break;
                        case '+':
                            $operands[$brackets] = $operands[$brackets] + $num;
                            break;
                    }
                    break;
                case '-':
                case '*':
                case '+':
                    $operations[$brackets] = $line[$i];
                    break;
                case '(':
                    $brackets++;
                    $operands[$brackets] = 0;
                    $operations[$brackets] = '';
                    break;
                case ')':
                    $num = $operands[$brackets];
                    $brackets--;
                    switch($operations[$brackets]) {
                        case '':
                            $operands[$brackets] = $num;
                            break;
                        case '*':
                            $operands[$brackets] = $operands[$brackets] * $num;
                            break;
                        case '+':
                            $operands[$brackets] = $operands[$brackets] + $num;
                            break;
                    }
                    break;
            }
        }
        return $operands[0];
    }
    
}
