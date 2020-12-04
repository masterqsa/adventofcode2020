namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict};

final class Day4 {
    use UtilsTrait;

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
byr:1937 iyr:2017 cid:147 hgt:183cm

iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
hcl:#cfa07d byr:1929

hcl:#ae17e1 iyr:2013
eyr:2024
ecl:brn pid:760753108 byr:1931
hgt:179cm

hcl:#cfa07d eyr:2025 pid:166559648
iyr:2011 ecl:brn hgt:59in
EOD;
$sample2 = <<<EOD
eyr:1972 cid:100
hcl:#18171d ecl:amb hgt:170 pid:186cm iyr:2018 byr:1926

iyr:2019
hcl:#602927 eyr:1967 hgt:170cm
ecl:grn pid:012533040 byr:1946

hcl:dab227 iyr:2012
ecl:brn hgt:182cm pid:021572410 eyr:2020 byr:1992 cid:277

hgt:59cm ecl:zzz
eyr:2038 hcl:74454a iyr:2023
pid:3556412378 byr:2007
EOD;
$sample3 = <<<EOD
pid:087499704 hgt:74in ecl:grn iyr:2012 eyr:2030 byr:1980
hcl:#623a2f

eyr:2029 ecl:blu cid:129 byr:1989
iyr:2014 pid:896056539 hcl:#a97842 hgt:165cm

hcl:#888785
hgt:164cm byr:2001 iyr:2015 cid:88
pid:545766238 ecl:hzl
eyr:2022

iyr:2010 hgt:158cm hcl:#b6652a ecl:blu byr:1944 eyr:2021 pid:093154719
EOD;
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

        $required = vec['byr','iyr','eyr','hgt','hcl','ecl','pid'];
        $optional = vec['cid'];
        $count = 0;
        $current = dict[];
        foreach($lines as $line) {
            if (Str\is_empty($line)) {
                if (static::isValid($required, $current)) {
                    $count++;
                }

                $current = dict[];
            } else {
                $entries = Str\split($line, " ");
                foreach($entries as $entry) {
                    $values = Str\split($entry, ":");
                    $current[$values[0]] = $values[1];
                }
            }
            //print("\n");
        }
        if (static::isValid($required, $current)) {
            $count++;
        }
        
        return "".$count;
    }

    public static function isValid(
        vec<string> $required,
        dict<string, string> $current,
    ): bool {
        $valid_fields = Dict\select_keys($current, $required);
        if (C\count($valid_fields) < C\count($required)) {
            return false;
        }
        
        $byr = Str\to_int($valid_fields["byr"]);
        if ($byr > 2002 || $byr < 1920) {
            //print("byr ".$valid_fields["byr"]."\n");
            return false;
        }
        $iyr = Str\to_int($valid_fields["iyr"]);
        if ($iyr > 2020 || $iyr < 2010) {
            //print("iyr ".$valid_fields["iyr"]."\n");
            return false;
        }
        $eyr = Str\to_int($valid_fields["eyr"]);
        if ($eyr > 2030 || $eyr < 2020) {
            //print("eyr ".$valid_fields["eyr"]."\n");
            return false;
        }
        $matches = Regex\every_match($valid_fields["hgt"], re"/([0-9]+)(in|cm)/");
        Vec\flatten($matches);
        if (C\is_empty($matches)) {
            //print("hgt ".$valid_fields["hgt"]."\n");
            return false;
        }
        if(C\count($matches[0]) === 1) {
            //print("hgt ".$valid_fields["hgt"]."\n");
            return false;
        } else {
            $hgt = Str\to_int($matches[0][1]);
            if ($matches[0][2] is null) {
                //print("hgt ".$valid_fields["hgt"]."\n");
                return false;
            } else {
                if ($matches[0][2] === "in") {
                    if ($hgt > 76 || $hgt < 59) {
                        //print("hgt in ".$valid_fields["hgt"]."\n");
                        return false;
                    }
                }
                if ($matches[0][2] === "cm") {
                    if ($hgt > 193 || $hgt < 150) {
                        //print("hgt cm ".$valid_fields["hgt"]."\n");
                        return false;
                    }
                }
            }
        }

        $matches = Regex\every_match($valid_fields["hcl"], re"/#[0-9a-f]{6}/");
        Vec\flatten($matches);
        if (C\is_empty($matches)) {
            //print("hcl ".$valid_fields["hcl"]."\n");
            return false;
        } else {
        }

        $matches = Regex\every_match($valid_fields["ecl"], re"/amb|blu|brn|gry|grn|hzl|oth/");
        Vec\flatten($matches);
        if (C\is_empty($matches)) {
            //print("ecl ".$valid_fields["ecl"]."\n");
            return false;
        } else {
        }

        if (Str\length($valid_fields["pid"]) !== 9) {
            //print("pid ".$valid_fields["pid"]."\n");
            return false;
        }
        $matches = Regex\every_match($valid_fields["pid"], re"/\d{9}/");
        Vec\flatten($matches);
        if (C\is_empty($matches)) {
            //print("pid ".$valid_fields["pid"]."\n");
            return false;
        } else {
        }

        foreach ($valid_fields as $field) {
            print($field." ");
        }
        print("\n");

        return true;
    }
}