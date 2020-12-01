<?hh

namespace AOC2020;

use namespace HH\Lib\{Str, Vec};

final class MainChecks {
  use UtilsTrait;
  public async function runLite(): Awaitable<void> {
    print("Lite\n");
  }
  
  public async function run<T>(
    vec<T> $values,
    vec<float> $float_values,
  ): Awaitable<void> {
    static::PrintTest();
    print('Hamming distance: '.hamming_distance($values, Vec\reverse($values))."\n");

    print('Edit distance: '.edit_distance($values, Vec\reverse($values))."\n");
    print('Edit distance: '.edit_distance(vec[1,2,3,4], vec[1,2,5,6,7])."\n");
    /* HH_IGNORE_ERROR[4110] */ 
    print(Str\join(min_max($float_values),'--')."\n");

    static::runSamplesAndActual(
      vec['one', 'two', 'three'],
      'actual!',
      inst_meth($this, 'doCase'),
    );
  }

  public function doCase(
    string $input,
  ): string {
    print($input."\n");
    return $input;
  }

  


}
