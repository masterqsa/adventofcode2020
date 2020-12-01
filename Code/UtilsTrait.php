<?hh

namespace AOC2020;

use namespace HH\Lib\{File, IO, Str, Math, Regex, Vec, C};

trait UtilsTrait {

public static function PrintTest(): void {
    print("Test\n");
}

public static function init_array<T>(
    int $n,
    ?T $default_value = null,
): vec<?T> {
    $array = vec[];
    foreach(Vec\range(0, $n) as $_i) {
        $array[] = $default_value;
    }
    return $array;
}

public static function init_array_not_null<T>(
    int $n,
    T $default_value,
): vec<T> {
    $array = vec[];
    foreach(Vec\range(0, $n) as $_i) {
        $array[] = $default_value;
    }
    return $array;
}

public static function init_2d_array<T>(
    int $m,
    int $n,
    ?T $default_value = null,
): vec<vec<?T>> {
    $array = vec[];
    foreach(Vec\range(0, $m) as $_j) {
        $subarray = init_array<T>($n, $default_value);
        $array[] = $subarray;
    }
    return $array;
}

public static function min_max(
    Traversable<num> $numbers,
): (num, num) {
  return tuple(Math\min($numbers) ?? 0, Math\max($numbers) ?? 0);
}

public static function max_minus_min(
    Traversable<num> $numbers,
): num {
    return (Math\min($numbers) ?? 0) - (Math\max($numbers) ?? 0);
}

public static function flatten<T>(
    Traversable<Container<T>> $matrix,
): Traversable<T> {
    return Vec\flatten($matrix);
}

public static function words(
    string $s,
): vec<string> {
    $matches = Regex\every_match($s, re"/[a-zA-Z]+/");
    return /* HH_IGNORE_ERROR[4110] */ Vec\flatten($matches);
}

public static function hamming_distance<T>(
    Traversable<T> $x,
    Traversable<T> $y,
): int {
    return C\reduce(
        Vec\zip($x, $y), 
        (int $init, (T, T) $pair): int ==> { return $init + ($pair[0]!=$pair[1]? 1 : 0);}, 
        0,
    );
}

public static function edit_distance<T>(
    vec<T> $a,
    vec<T> $b,
): int {
    $n = C\count($a);
    $m = C\count($b);
    $dp = init_2d_array($n, $m);
    $dp[$n][$m] = 0;
    return edit_distance_aux($dp, $a, $b, 0, 0);
}

public static function edit_distance_aux<T>(
    vec<vec<?int>> $dp,
    vec<T> $a,
    vec<T> $b,
    int $i,
    int $j,
): int {
    $n = C\count($dp)-1;
    $m = C\count($dp[0])-1;
    assert(0<=$i && $i<=$n);
    assert(0<=$j && $j<=$m);

    if ($dp[$i][$j] is nonnull) {
        return $dp[$i][$j] ?? 0;
    }

    if ($i === $n) {
        $dp[$i][$j] = 1 + edit_distance_aux($dp, $a, $b, $i, $j + 1);
    } else if ($j === $m) {
        $dp[$i][$j] = 1 + edit_distance_aux($dp, $a, $b, $i + 1, $j);
    } else {
        $dp[$i][$j] = Math\min(
            vec[
                ($a[$i] == $b[$j] ? 0 : 1) + edit_distance_aux($dp, $a, $b, $i + 1, $j + 1),
                1 + edit_distance_aux($dp, $a, $b, $i + 1, $j),
                1 + edit_distance_aux($dp, $a, $b, $i, $j + 1),
            ]
        );
    }

    return $dp[$i][$j] ?? 0;
}

public static function parseSamples(
    Traversable<string> $input,
): vec<string> {
    return Vec\filter($input, $s ==> $s is nonnull && $s !== '');
}

public static function runSamplesAndActual(
    Traversable<string> $samples,
    string $actual,
    (function(string): string) $do_case,
): void {
    $p = static::parseSamples($samples);
    foreach($p as $sample) {
        print('running '.Str\slice($sample, 0, 100).":\n");
        print(Str\repeat('-', 10)."\n");
        print($do_case($sample)."\n");
        print(Str\repeat('-', 10)."\n");
        print(Str\repeat('#', 10)."\n");
    }
    if (!Str\is_empty($actual)) {
        print("!! running actual !!");
        print(Str\repeat('-', 10)."\n");
        print($do_case($actual)."\n");
        print(Str\repeat('-', 10)."\n");
    }
}

}