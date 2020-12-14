namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

<<__EntryPoint>>
async function main(): Awaitable<void> {
    require_once(__DIR__.'/vendor/autoload.hack');
    \Facebook\AutoloadMap\initialize();

    $current_day = new Day14();

    await $current_day->runProcessing();

}