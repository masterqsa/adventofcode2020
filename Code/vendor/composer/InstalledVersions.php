<?php

namespace Composer;

use Composer\Semver\VersionParser;






class InstalledVersions
{
private static $installed = array (
  'root' => 
  array (
    'pretty_version' => 'dev-master',
    'version' => 'dev-master',
    'aliases' => 
    array (
    ),
    'reference' => '3f7bf4ddb7cb2dc7a7ae9a8e191ec77a6743e3d3',
    'name' => '__root__',
  ),
  'versions' => 
  array (
    '__root__' => 
    array (
      'pretty_version' => 'dev-master',
      'version' => 'dev-master',
      'aliases' => 
      array (
      ),
      'reference' => '3f7bf4ddb7cb2dc7a7ae9a8e191ec77a6743e3d3',
    ),
    'facebook/difflib' => 
    array (
      'pretty_version' => 'v1.2.0',
      'version' => '1.2.0.0',
      'aliases' => 
      array (
      ),
      'reference' => 'b697c0ac436629c8cd9627ab31a60777431f72f6',
    ),
    'facebook/fbexpect' => 
    array (
      'pretty_version' => 'v2.7.7',
      'version' => '2.7.7.0',
      'aliases' => 
      array (
      ),
      'reference' => 'dcf1beb1b9e264396495aa120a3752fddfbeca95',
    ),
    'facebook/hh-clilib' => 
    array (
      'pretty_version' => 'v2.5.2',
      'version' => '2.5.2.0',
      'aliases' => 
      array (
      ),
      'reference' => '17b7ceffa24d9ed5dce4145025e3dea476ff6d88',
    ),
    'facebook/hhvm-autoload' => 
    array (
      'replaced' => 
      array (
        0 => '1.*',
      ),
    ),
    'hhvm/hacktest' => 
    array (
      'pretty_version' => 'v2.2.0',
      'version' => '2.2.0.0',
      'aliases' => 
      array (
      ),
      'reference' => 'aa2167eb5ed52d8a8e437272f9474a86103a50ca',
    ),
    'hhvm/hhast' => 
    array (
      'pretty_version' => 'v4.84.0',
      'version' => '4.84.0.0',
      'aliases' => 
      array (
      ),
      'reference' => 'be354d65b55ed502f5b49695cf0fc36b1a377cfa',
    ),
    'hhvm/hhvm-autoload' => 
    array (
      'pretty_version' => 'v3.1.6',
      'version' => '3.1.6.0',
      'aliases' => 
      array (
      ),
      'reference' => '9fbe10a1a11783085f3165cceb102b67af403aca',
    ),
    'hhvm/hsl' => 
    array (
      'pretty_version' => 'v4.41.0',
      'version' => '4.41.0.0',
      'aliases' => 
      array (
      ),
      'reference' => '80a42c02f036f72a42f0415e80d6b847f4bf62d5',
    ),
    'hhvm/hsl-experimental' => 
    array (
      'pretty_version' => 'v4.66.0',
      'version' => '4.66.0.0',
      'aliases' => 
      array (
      ),
      'reference' => '1491b97fffd1db91fd7254d2bae10c20eb01e3e0',
    ),
    'hhvm/hsl-io' => 
    array (
      'provided' => 
      array (
        0 => '0.2.1',
      ),
    ),
    'hhvm/type-assert' => 
    array (
      'pretty_version' => 'v4.1.2',
      'version' => '4.1.2.0',
      'aliases' => 
      array (
      ),
      'reference' => '0983260af4dc918b33ca154757b537daa38c88a0',
    ),
  ),
);







public static function getInstalledPackages()
{
return array_keys(self::$installed['versions']);
}









public static function isInstalled($packageName)
{
return isset(self::$installed['versions'][$packageName]);
}














public static function satisfies(VersionParser $parser, $packageName, $constraint)
{
$constraint = $parser->parseConstraints($constraint);
$provided = $parser->parseConstraints(self::getVersionRanges($packageName));

return $provided->matches($constraint);
}










public static function getVersionRanges($packageName)
{
if (!isset(self::$installed['versions'][$packageName])) {
throw new \OutOfBoundsException('Package "' . $packageName . '" is not installed');
}

$ranges = array();
if (isset(self::$installed['versions'][$packageName]['pretty_version'])) {
$ranges[] = self::$installed['versions'][$packageName]['pretty_version'];
}
if (array_key_exists('aliases', self::$installed['versions'][$packageName])) {
$ranges = array_merge($ranges, self::$installed['versions'][$packageName]['aliases']);
}
if (array_key_exists('replaced', self::$installed['versions'][$packageName])) {
$ranges = array_merge($ranges, self::$installed['versions'][$packageName]['replaced']);
}
if (array_key_exists('provided', self::$installed['versions'][$packageName])) {
$ranges = array_merge($ranges, self::$installed['versions'][$packageName]['provided']);
}

return implode(' || ', $ranges);
}





public static function getVersion($packageName)
{
if (!isset(self::$installed['versions'][$packageName])) {
throw new \OutOfBoundsException('Package "' . $packageName . '" is not installed');
}

if (!isset(self::$installed['versions'][$packageName]['version'])) {
return null;
}

return self::$installed['versions'][$packageName]['version'];
}





public static function getPrettyVersion($packageName)
{
if (!isset(self::$installed['versions'][$packageName])) {
throw new \OutOfBoundsException('Package "' . $packageName . '" is not installed');
}

if (!isset(self::$installed['versions'][$packageName]['pretty_version'])) {
return null;
}

return self::$installed['versions'][$packageName]['pretty_version'];
}





public static function getReference($packageName)
{
if (!isset(self::$installed['versions'][$packageName])) {
throw new \OutOfBoundsException('Package "' . $packageName . '" is not installed');
}

if (!isset(self::$installed['versions'][$packageName]['reference'])) {
return null;
}

return self::$installed['versions'][$packageName]['reference'];
}





public static function getRootPackage()
{
return self::$installed['root'];
}







public static function getRawData()
{
return self::$installed;
}



















public static function reload($data)
{
self::$installed = $data;
}
}
