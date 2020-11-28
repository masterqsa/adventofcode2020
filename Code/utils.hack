namespace AOC2020 {

use namespace HH\Lib\{File, IO, Str, Math, Regex, Vec, C};

function init_array<T>(
    int $n,
    ?T $default_value = null,
): vec<?T> {
    $array = vec[];
    foreach(Vec\range(0, $n) as $_i) {
        $array[] = $default_value;
    }
    return $array;
}

function init_2d_array<T>(
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

function min_max(
    Traversable<T> $numbers,
): (number, number) {
  return tuple(Math\min($numbers), Math\max($numbers));
}

function max_minus_min(
    Traversable<T> $numbers,
): number {
    return Math\min($numbers) - Math\max($numbers);
}

function flatten(
    Traversable<Traversable<T>> $matrix,
): Traversable<T> {
    return Vec\flatten($matrix);
}

function words(
    string $s,
): vec<string> {
    return Vec\flatten(Regex\every_match($s, re"/[a-zA-Z]+/"));
}

function hamming_distance(
    Traversable<T> $x,
    Traversable<T> $y,
): int {
    return C\reduce(
        Vec\zip($x, $y), 
        (int $init, (T, T) $pair): int ==> { return $init + ($pair[0]!=$pair[1]? 1 : 0);}, 
        0,
    );
}

function edit_distance(
    Traversable<T> $a,
    Traversable<T> $b,
): int {
    $n = C\count($a);
    $m = C\count($b);
    $dp = init_2d_array($n, $m);
    $dp[$n][$m] = 0;
    return edit_distance_aux($dp, $a, $b, 0, 0);
}

function edit_distance_aux(
    vec<vec<int>> $dp,
    Traversable<T> $a,
    Traversable<T> $b,
    int $i,
    int $j,
): int {
    $n = C\count($dp)-1;
    $m = C\count($dp[0])-1;
    assert(0<=$i && $i<=$n);
    assert(0<=$j && $j<=$m);

    if ($dp[$i][$j] is nonnull) {
        return $dp[$i][$j];
    }

    if ($i === $n) {
        $dp[$i][$j] = 1 + edit_distance_aux($dp, $a, $b, $i, $j + 1);
    } else if ($j === $m) {
        $dp[$i][$j] = 1 + edit_distance_aux($dp, $a, $b, $i + 1, $j);
    } else {
        $dp[$i][$j] = Math\min(
            vec[
                ($a[$i] === $b[$j] ? 0 : 1) + edit_distance_aux($dp, $a, $b, $i + 1, $j + 1),
                1 + edit_distance_aux($dp, $a, $b, $i + 1, $j),
                1 + edit_distance_aux($dp, $a, $b, $i, $j + 1),
            ]
        );
    }

    return $dp[$i][$j];
}


}