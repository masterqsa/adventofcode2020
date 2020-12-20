namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec, Dict, Keyset};

newtype TileRotation = (int, int); //tile #, tile rotation
newtype Match = (int, int, int); 

final class Day20 {
    use UtilsTrait;

    public $tiles = dict<int, vec<vec<string>>>[];
    public $tile_indexes = vec<int>[];
    public $signature_sets = dict<int, vec<vec<string>>>[];
    public $grid = vec<vec<string>>[];

    public async function runProcessing(): Awaitable<void> {
        $f = File\open_read_only(__DIR__."/input.txt");
        $s = await $f->readAllAsync();

$sample1 = <<<EOD
Tile 2311:
..##.#..#.
##..#.....
#...##..#.
####.#...#
##.##.###.
##...#.###
.#.#.#..##
..#....#..
###...#.#.
..###..###

Tile 1951:
#.##...##.
#.####...#
.....#..##
#...######
.##.#....#
.###.#####
###.##.##.
.###....#.
..#.#..#.#
#...##.#..

Tile 1171:
####...##.
#..##.#..#
##.#..#.#.
.###.####.
..###.####
.##....##.
.#...####.
#.##.####.
####..#...
.....##...

Tile 1427:
###.##.#..
.#..#.##..
.#.##.#..#
#.#.#.##.#
....#...##
...##..##.
...#.#####
.#.####.#.
..#..###.#
..##.#..#.

Tile 1489:
##.#.#....
..##...#..
.##..##...
..#...#...
#####...#.
#..#.#.#.#
...#.#.#..
##.#...##.
..##.##.##
###.##.#..

Tile 2473:
#....####.
#..#.##...
#.##..#...
######.#.#
.#...#.#.#
.#########
.###.#..#.
########.#
##...##.#.
..###.#.#.

Tile 2971:
..#.#....#
#...###...
#.#.###...
##.##..#..
.#####..##
.#..####.#
#..#.#..#.
..####.###
..#.#.###.
...#.#.#.#

Tile 2729:
...#.#.#.#
####.#....
..#.#.....
....#..#.#
.##..##.#.
.#.####...
####.#.#..
##.####...
##..#.##..
#.##...##.

Tile 3079:
#.#.#####.
.#..######
..#.......
######....
####.#..#.
.#...#.##.
#.#####.##
..#.###...
..#.......
..#.###...

EOD;
$sample2 = null;
$sample3 = null;
        static::runSamplesAndActual(
            vec[$sample1, $sample2, $sample3],
            $s,
            inst_meth($this, 'doCase'),
        );
    }

    public function doCase(
        string $input,
    ): string {
        $this->tiles = dict<int, vec<vec<string>>>[];
        $this->tile_indexes = vec[];
        $this->grid = vec<vec<string>>[];
        $lines = Str\split($input, "\n");
        $sum = 0;
        $count = 0;
        $layout = vec<vec<TileRotation>>[];
        $current = vec<vec<string>>[];
        $current_index = 0;
        foreach($lines as $line) {
            if ($line === '') {
                $this->tiles[$current_index] = $current;
                $current = vec<vec<string>>[];
            } else if (Str\starts_with($line, 'Tile')) {
                $parts = Str\split($line, ' ');
                $current_index = Str\to_int(Str\replace($parts[1], ':', ''));
                $this->tile_indexes[] = $current_index;
                //print($current_index."\n");
            } else {
                $row = vec<string>[];
                for($i = 0; $i < Str\length($line); $i++) {
                    $row[] = $line[$i];
                }
                $current[] = $row;
            }
            
        }

        $this->signature_sets = dict<int, vec<vec<string>>>[];
        foreach($this->tile_indexes as $idx) {
            $this->signature_sets[$idx] = vec<vec<string>>[];
            for($i = 0; $i <= 3; $i++) {
                $rotation = $this->rotate($this->tiles[$idx], $i);
                $this->signature_sets[$idx][] = $this->calcSignatures($rotation);
                if ($i < 2) {
                    $flip1 = $this->flip($rotation, 1);
                    $flip2 = $this->flip($rotation, 2);
                    $this->signature_sets[$idx][] = $this->calcSignatures($flip1);
                    $this->signature_sets[$idx][] = $this->calcSignatures($flip2);
                }
            }
        }

        $mult = 1;
        $corners = vec[];
        foreach($this->tile_indexes as $idx1) {
            $matches = 0;
            foreach($this->tile_indexes as $idx2) {
                $max_match = 0;
                if ($idx1 != $idx2) {
                    foreach($this->signature_sets[$idx2] as $ss2){
                        $match = $this->matchSignatures($this->signature_sets[$idx1][0], $ss2);
                        if ($match[0] > -1) {
                            $max_match = 1;
                        }
                    }
                }
                if ($max_match > 0) {
                    $matches++;
                }
            }
            if ($matches === 2) {
                $corners[] = $idx1;
                $mult*=$idx1;
            }
        }

        print("tiles: ".C\count($this->tiles)."\n");
        print("size: ".C\count($this->tiles[$this->tile_indexes[0]])."\n");

        print("corner mult: ".$mult."\n");

        
        $good_match = 0;
        for($i = 0; $i < 4; $i++) {
            $exact_matches_left = $this->matchExactSig($corners[$i], 1, 3); //right side matches left
            $exact_matches_bottom = $this->matchExactSig($corners[$i], 2, 0); //right side matches left
            foreach($exact_matches_left as $exact_match) {
                print("left match for ".$corners[$i]." set ".$exact_match[0]." -> tile ".$exact_match[1]." set ".$exact_match[2]."\n");
                foreach($exact_matches_bottom as $exact_match_bottom) {
                    if ($exact_match[0] === $exact_match_bottom[0]) {
                        print("bottom match for ".$corners[$i]." set ".$exact_match_bottom[0]." -> tile ".$exact_match_bottom[1]." set ".$exact_match_bottom[2]."\n");
                        $good_match = $corners[$i];
                        $good_orientation = $exact_match_bottom[0];
                        print("good left corner: ".$good_match."\n");
                    }
                }
            }
        }

        $layout[] = vec<TileRotation>[];
        $layout[0][] = tuple($good_match, $good_orientation); //leftmost top tile placed without rotations
        $grid_side = Math\sqrt(C\count($this->tiles));
        $used = keyset[];
        for($i = 0; $i < $grid_side - 1;$i++) {
            $idx = $layout[0][$i][0];
            print($idx.":");

            $rotation = $layout[0][$i][1];
            print($rotation.", ");

            $exact_matches_left = Vec\filter($this->matchExactSig($idx, 1, 3), $m ==> $m[0] === $rotation && !C\contains_key($used, $m[1]));
            print(C\count($exact_matches_left)." options, ");
            
            $next_tile = $exact_matches_left[0][1];
            $used[] = $next_tile;
            $next_rotation = $exact_matches_left[0][2];
            $layout[0][] = tuple($next_tile, $next_rotation);
            print($next_tile." + ".$next_rotation."\n");
        }
        
        for($j = 1; $j < $grid_side;$j++) {
            print("-----***----\n");
            $layout[] = vec<TileRotation>[];
            for($i = 0; $i < $grid_side;$i++) {
                $idx = $layout[$j-1][$i][0];
                print($idx .":");

                $rotation = $layout[$j-1][$i][1];
                print($rotation.", ");

                $exact_matches_bottom = Vec\filter($this->matchExactSig($idx, 2, 0), $m ==> $m[0] === $rotation);
                print(C\count($exact_matches_bottom)." options, ");
            
                $layout[$j][] = tuple($exact_matches_bottom[0][1], $exact_matches_bottom[0][2]);
                print($exact_matches_bottom[0][1]." + ".$exact_matches_bottom[0][2]."\n");
            }
        }
        $tile_size = C\count($this->tiles[$this->tile_indexes[0]]);
        for($x = 0; $x < $grid_side; $x++){
            for($i = 1; $i < $tile_size-1; $i++) {
                $this->grid[] = vec<string>[];
            }
            for($y = 0; $y < $grid_side; $y++) {
                $tile = $this->getRotation($this->tiles[$layout[$x][$y][0]], $layout[$x][$y][1]);
                for($i = 1; $i < $tile_size-1; $i++) {
                    for($j = 1; $j < $tile_size-1; $j++) {
                        $this->grid[$x * ($tile_size-2) + $i - 1][] = $tile[$i][$j];
                    }
                }
            }
        }

        $min_count = 1000000;

        for($r = 0; $r < 8; $r++) {
            $count = 0;
            $tile = $this->getRotation($this->grid, $r);
            for($i = 0; $i < C\count($tile); $i++) {
                for($j = 0; $j < C\count($tile); $j++) {
                    if ($grid_side < 12) print($tile[$i][$j]);
                    if ($tile[$i][$j] === '#'){
                        $count++;
                        if ($this->partOfMonster($tile, $i, $j)) {
                            $count-= 15;
                        }
                    } 
                }
                if ($grid_side < 12) print("\n");
            }
            if ($count < $min_count) {
                $min_count = $count;
            }
            if ($grid_side < 12) print("\n");
        }
        print("not part of monster: ".$min_count."\n");      
        return "".$count;
    }

    public function partOfMonster(vec<vec<string>> $tile, int $i, int $j): bool {
        $tile_size = C\count($tile);
        if ($j < 18 || $j > $tile_size - 2 || $i > $tile_size - 3) {
            return false;
        }
        $lines = vec['#    ##    ##    ###', ' #  #  #  #  #  #   '];
        for($l = 0; $l <= 1; $l++) {
            $line = $lines[$l];
            for($p = 0; $p < Str\length($line); $p++) {
                if ($line[$p]==='#' && $tile[$i+1+$l][$j - 18 +$p] !== '#') {
                    return false;
                }
            }
        }
        return true;
    }

    public function getRotation(vec<vec<string>> $tile, int $type): vec<vec<string>> {
        switch($type){
            case 0: return $tile;
            case 1: return $this->flip($tile, 1);
            case 2: return $this->flip($tile, 2);
            case 3: return $this->rotate($tile, 1);
            case 4: return $this->flip($this->rotate($tile, 1),1);
            case 5: return $this->flip($this->rotate($tile, 1),2);
            case 6: return $this->rotate($tile, 2);
            case 7: return $this->rotate($tile, 3);
        }
    }

    public function flip(vec<vec<string>> $tile, int $type): vec<vec<string>> {
        $result = vec<vec<string>>[];
        if ($type === 0) {
            return $tile;
        }
        $size = C\count($tile);
        if ($type === 1) {
            for($i = $size - 1; $i >= 0; $i--) {
                $result[] = $tile[$i];              
            }
        } else {
            for($i = 0; $i < $size; $i++){
                $result[] = Vec\reverse($tile[$i]);
            }
        }
        return $result;
    }

    public function rotate(vec<vec<string>> $tile, int $angle): vec<vec<string>> {
        $result = vec<vec<string>>[];
        $size = C\count($tile);
        switch($angle){
            case 0: 
                return $tile;
            case 1:
                for($i = 0; $i < $size; $i++){
                    $row = vec<string>[];
                    for($j = 0; $j < $size; $j++){
                        $row[] = $tile[$size - $j - 1][$i];
                    }
                    $result[] = $row;
                }
                break;
            case 2:
                for($i = $size - 1; $i >= 0; $i--) {
                    $result[] = Vec\reverse($tile[$i]);              
                }
                break;
            case 3:
                for($i = 0; $i < $size; $i++){
                    $row = vec<string>[];
                    for($j = 0; $j < $size; $j++){
                        $row[] = $tile[$j][$size - $i - 1];
                    }
                    $result[] = $row;
                }
                break;
        }
        return $result;
    }

    // top, right, bottom, left
    public function calcSignatures(vec<vec<string>> $tile): vec<string> {
        $result = vec[];
        $size = C\count($tile);
        $s1 = '';
        $s2 = '';
        $s3 = '';
        $s4 = '';
        for($i = 0; $i < $size; $i++){
            $s1 = $s1.$tile[0][$i];
            $s2 = $s2.$tile[$i][$size-1];
            $s3 = $s3.$tile[$size-1][$i];
            $s4 = $s4.$tile[$i][0];
        }
        return vec[$s1, $s2, $s3, $s4];
    }
    
    public function matchSignatures(vec<string> $sig1, vec<string> $sig2): (int, int) {
        for($i = 0; $i < C\count($sig1); $i++) {
            for($j = 0; $j < C\count($sig2); $j++) {
                if ($sig1[$i] === $sig2[$j]) {
                    return tuple($i, $j);
                }
            }
        }
        return tuple(-1, -1);C\count(Vec\intersect($sig1, $sig2));
    }

    public function matchExactSig(
        int $idx1,
        int $side1, 
        int $side2,
    ): vec<Match> {
        $result = vec[];
        $sigs1 = $this->signature_sets[$idx1];
        foreach($this->tile_indexes as $idx2) {
            if ($idx1 !== $idx2) {
                $sigs2 = $this->signature_sets[$idx2];
                for($i = 0; $i < C\count($sigs1); $i++) {
                    for($j = 0; $j < C\count($sigs2); $j++) {
                        if ($sigs1[$i][$side1] === $sigs2[$j][$side2]) {
                            $result[] = tuple($i, $idx2, $j);
                        }
                    }
                }
            }
        }
        if (C\count($result)>0) {
            return $result;
        }

        return vec[tuple(-1, -1, -1)];
    }

}
