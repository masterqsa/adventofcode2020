<?hh

namespace AOC2020;

use namespace HH\Lib\{File, IO, Str, Math, Regex, Vec, C};

final class MainChecks {
  use UtilsTrait;
  public async function RunLite(): Awaitable<void> {
    print("Lite\n");
  }
  
  public async function Run(): Awaitable<void> {
      static::PrintTest();
  }
}
