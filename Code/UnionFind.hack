namespace AOC2020;

use namespace HH\Lib\{C, File, IO, Str, Math, Regex, Vec};

class UnionFind {
    use UtilsTrait;

    private int $n;
    private vec<?int> $parents;
    private vec<int> $ranks;
    public int $num_sets;

    public function __construct(int $n) {
        $this->n = $n;
        $this->num_sets = $n;
        $this->parents = static::init_array<int>($n);
        $this->ranks = static::init_array_not_null<int>($n, 1);
    }

    public function find(int $i): int {
        $p = $this->parents[$i];
        if ($p is null) {
            return $i;
        }
        $p = $this->find($p);
        $this->parents[$i] = $p;
        return $p;
    }

    public function in_same_set(
        int $i,
        int $j,
    ): bool {
        return $this->find($i) === $this->find($j);
    }

    public function merge(
        int $i,
        int $j,
    ): void {
        $i = $this->find($i);
        $j = $this->find($j);
        if ($i == $j) return;

        $i_rank = $this->ranks[$i];
        $j_rank = $this->ranks[$j];

        if ($i_rank < $j_rank) {
            $this->parents[$i] = $j;
        } else if ($i_rank > $j_rank) {
            $this->parents[$j] = $i;
        } else {
            $this->parents[$j] = $i;
            $this->ranks[$i]+= 1;
        }
        $this->num_sets-=1;
    }
}