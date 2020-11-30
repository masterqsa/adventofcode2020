<?hh

namespace AOC2020;

use namespace HH\Lib\{File, IO, Str, Math, Regex, Vec, C};

final class MainChecks {
  use UtilsTrait;
  public async function RunLite(): Awaitable<void> {
    print("Lite\n");
  }
  
  public async function Run<T>(
    vec<T> $values,
    vec<float> $float_values,
  ): Awaitable<void> {
    static::PrintTest();
    print("Hamming distance: ".hamming_distance($values, Vec\reverse($values))."\n");

    print("Edit distance: ".edit_distance($values, Vec\reverse($values))."\n");
    print("Edit distance: ".edit_distance(vec[1,2,3,4], vec[1,2,5,6,7])."\n");
    /* HH_IGNORE_ERROR[4110] */ 
    print(Str\join(min_max($float_values),"--")."\n");

  }
}
