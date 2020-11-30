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

}