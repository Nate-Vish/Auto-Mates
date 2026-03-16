# Data Structures & Algorithms
**When to use:** Read when choosing data structures for performance-sensitive code, implementing search/sort, or optimizing loops.

---

## Big O — Mental Model

| Notation | Name | Example | Feel |
|----------|------|---------|------|
| O(1) | Constant | Hash map lookup | Instant, regardless of size |
| O(log n) | Logarithmic | Binary search | Halving the problem each step |
| O(n) | Linear | Single loop over array | Touch every element once |
| O(n log n) | Linearithmic | Merge sort, quick sort | Efficient sorting ceiling |
| O(n^2) | Quadratic | Nested loops | Every pair — slows fast |
| O(2^n) | Exponential | Recursive subsets | Doubles each step — avoid |

**Practical rule:** If data can reach 10,000+ items, anything above O(n log n) needs justification.

---

## When to Use Which Structure

| Need | Best Choice | Why |
|------|------------|-----|
| Ordered collection with index access | **Array** | O(1) access by index |
| Fast lookup by key | **Map** | O(1) get/set |
| Check membership / dedup | **Set** | O(1) has/add |
| LIFO processing | **Stack** (Array) | push/pop are O(1) |
| FIFO processing | **Queue** (custom) | Avoid Array.shift() |
| Sorted data with fast search | **BST** or sorted Array + binary search | O(log n) search |
| Priority processing | **Heap** | O(log n) insert/extract |
| Relationships between entities | **Graph** (adjacency list) | Natural for connected data |

---

## Arrays

| Operation | Complexity |
|-----------|-----------|
| Access by index | O(1) |
| Push / Pop (end) | O(1) amortized |
| Shift / Unshift (front) | O(n) |
| Search (unsorted) | O(n) |
| Search (sorted, binary) | O(log n) |
| Insert/delete (middle) | O(n) |

---

## Stack & Queue

```typescript
// Stack (LIFO) — using array
const stack: string[] = [];
stack.push("a"); stack.push("b");
stack.pop();  // "b"

// Queue (FIFO) — avoid Array.shift() (O(n))
class Queue<T> {
  private items: Map<number, T> = new Map();
  private head = 0; private tail = 0;

  enqueue(item: T): void { this.items.set(this.tail++, item); }
  dequeue(): T | undefined {
    if (this.head === this.tail) return undefined;
    const item = this.items.get(this.head);
    this.items.delete(this.head++);
    return item;
  }
  get size(): number { return this.tail - this.head; }
}
```

---

## Hash Maps & Sets

```typescript
// Frequency counter — classic Map pattern
function countFrequencies(arr: string[]): Map<string, number> {
  const freq = new Map<string, number>();
  for (const item of arr) {
    freq.set(item, (freq.get(item) ?? 0) + 1);
  }
  return freq;
}

// Deduplication — classic Set pattern
function unique<T>(arr: T[]): T[] { return [...new Set(arr)]; }

// O(n) two-sum with Map instead of O(n^2) nested loops
function twoSum(nums: number[], target: number): [number, number] | null {
  const seen = new Map<number, number>();
  for (let i = 0; i < nums.length; i++) {
    const complement = target - nums[i];
    if (seen.has(complement)) return [seen.get(complement)!, i];
    seen.set(nums[i], i);
  }
  return null;
}
```

---

## Graphs

```typescript
type Graph = Map<string, string[]>;

function buildGraph(edges: [string, string][]): Graph {
  const graph: Graph = new Map();
  for (const [a, b] of edges) {
    if (!graph.has(a)) graph.set(a, []);
    if (!graph.has(b)) graph.set(b, []);
    graph.get(a)!.push(b);
    graph.get(b)!.push(a); // remove for directed graph
  }
  return graph;
}
```

---

## Essential Algorithms

### Binary Search — O(log n)
```typescript
function binarySearch(arr: number[], target: number): number {
  let lo = 0; let hi = arr.length - 1;
  while (lo <= hi) {
    const mid = lo + Math.floor((hi - lo) / 2);
    if (arr[mid] === target) return mid;
    if (arr[mid] < target) lo = mid + 1;
    else hi = mid - 1;
  }
  return -1;
}
```

### BFS — Shortest path in unweighted graphs
```typescript
function bfs(graph: Graph, start: string): string[] {
  const visited = new Set<string>([start]);
  const queue: string[] = [start];
  const result: string[] = [];
  while (queue.length > 0) {
    const node = queue.shift()!;
    result.push(node);
    for (const neighbor of graph.get(node) ?? []) {
      if (!visited.has(neighbor)) { visited.add(neighbor); queue.push(neighbor); }
    }
  }
  return result;
}
```

### DFS — All paths, cycle detection, topological sort
```typescript
function dfs(graph: Graph, start: string): string[] {
  const visited = new Set<string>();
  const result: string[] = [];
  function explore(node: string): void {
    if (visited.has(node)) return;
    visited.add(node); result.push(node);
    for (const neighbor of graph.get(node) ?? []) explore(neighbor);
  }
  explore(start);
  return result;
}
```

---

## Algorithm Patterns

### Two Pointers — sorted array problems, O(n)
```typescript
function twoSumSorted(nums: number[], target: number): [number, number] | null {
  let left = 0; let right = nums.length - 1;
  while (left < right) {
    const sum = nums[left] + nums[right];
    if (sum === target) return [left, right];
    if (sum < target) left++; else right--;
  }
  return null;
}
```

### Sliding Window — subarray/substring problems, O(n)
```typescript
function longestUniqueSubstring(s: string): number {
  const seen = new Map<string, number>();
  let maxLen = 0; let start = 0;
  for (let end = 0; end < s.length; end++) {
    const char = s[end];
    if (seen.has(char) && seen.get(char)! >= start) start = seen.get(char)! + 1;
    seen.set(char, end);
    maxLen = Math.max(maxLen, end - start + 1);
  }
  return maxLen;
}
```

### Memoization
```typescript
function fib(n: number, memo = new Map<number, number>()): number {
  if (n <= 1) return n;
  if (memo.has(n)) return memo.get(n)!;
  const result = fib(n - 1, memo) + fib(n - 2, memo);
  memo.set(n, result);
  return result;
}
```

---

## JS/TS Built-in Complexity

| Method | Complexity | Notes |
|--------|-----------|-------|
| `arr[i]` | O(1) | Direct index access |
| `push()` / `pop()` | O(1) | End operations |
| `shift()` / `unshift()` | O(n) | Reindexes all elements |
| `includes()` / `indexOf()` | O(n) | Linear scan |
| `filter()` / `map()` / `forEach()` | O(n) | Full iteration |
| `sort()` | O(n log n) | TimSort — ALWAYS pass a comparator for numbers |
| `Map.get()` / `Map.has()` / `Map.set()` | O(1) avg | Hash table |
| `Set.has()` / `Set.add()` | O(1) avg | Hash table |

---

## Common Mistakes

```typescript
// 1. Array.includes() in a loop → O(n*m)
// BAD:
for (const item of listA) { if (listB.includes(item)) { } }
// GOOD: O(n + m)
const setB = new Set(listB);
for (const item of listA) { if (setB.has(item)) { } }

// 2. Array.shift() as a queue → O(n) total becomes O(n^2)
// Use the Queue class above instead

// 3. sort() without a comparator — converts to strings
[10, 2, 30].sort();          // [10, 2, 30] — WRONG!
[10, 2, 30].sort((a, b) => a - b); // [2, 10, 30] — CORRECT

// 4. Nested loops when a Map solves it in O(n)
// See twoSum example above
```

---

## Daily Rules

1. Know your N — estimate max input size before choosing structure
2. Default to Map/Set for lookups — not Array.includes()
3. Profile before optimizing — O(n^2) on 50 items may be fine
4. Use built-in sort with a comparator, not a sort algorithm
5. Recognize patterns: frequency counting (Map), dedup (Set), LIFO/FIFO (Stack/Queue), graph traversal (BFS/DFS)
6. Space-time tradeoff: when O(n^2) seems required, ask if a Map brings it to O(n)
