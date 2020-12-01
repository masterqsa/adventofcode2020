namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

<<__EntryPoint>>
async function main(): Awaitable<void> {
  require_once(__DIR__.'/vendor/autoload.hack');
  \Facebook\AutoloadMap\initialize();
  require_once(__DIR__.'/utils.hack');

  print( "Hello world!\n\n" );

  $checks = new MainChecks();
  await $checks->runLite();

  $values = vec[];
  $float_values = vec[];
  $f = File\open_read_only(__DIR__."/input.txt");
  $s = await $f->readAsync();
  foreach(Str\split($s, "\n") as $line) {
    print($line.", ");
    $values[] = Str\to_int($line);
    $float_values[] = \floatval($line);
  }
  print("\n\n");

  await $checks->run($values, $float_values);


  print($s."\n");
  
  foreach($float_values as $fv) {
    print($fv."+");
  }

  print("\n\n");

  // STDIN for CLI, or HTTP POST data
  $_in = IO\request_input();
  // STDOUT for CLI, or HTTP response
  $out = IO\request_output();

  $message = "Hello, world\n";
  $words = words($message);
  print(Str\join(words($message), " ")."\n\n");
  await $out->writeAllAsync($message);

  // copy to a temporary file, automatically closed at scope exit
  using ($tf = File\temporary_file()) {
    $f = $tf->getHandle();

    await $f->writeAllAsync($message);

    $f->seek(0);
    $content = await $f->readAsync();
    await $out->writeAllAsync($content);
  }

  $uf = new UnionFind(5);
  $uf->merge(1, 2);
  print(($uf->in_same_set(1,2) ? "true":"false").", ".($uf->in_same_set(1,3) ? "true":"false").", ".$uf->num_sets.".\n");
}