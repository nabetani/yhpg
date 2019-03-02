package main

import (
	"fmt"
	"strconv"
	"strings"
	"time"
)

func isGuru(b, i int64) bool {
	prev := (*int64)(nil)
	for {
		num := i % b
		i = (i - num) / b
		if prev != nil {
			if *prev != num && *prev != (num+1)%b {
				return false
			}
		}
		if i == 0 {
			return true
		}
		prev = &num
	}
}

func impl(b, x, y int64) int64 {
	c := int64(0)
	for i := x; i <= y; i++ {
		if isGuru(b, i) {
			c++
		}
	}
	return c
}

func solveSlow(src string) string {
	vals := strings.Split(src, ",")
	b, _ := strconv.Atoi(vals[0])
	x, _ := strconv.ParseInt(vals[1], b, 64)
	y, _ := strconv.ParseInt(vals[2], b, 64)
	//fmt.Println(vals, b, x, y)
	count := impl(int64(b), x, y)
	return fmt.Sprint(count)
}

func test() {
	type dataType struct {
		src, expected string
	}
	data := []dataType{
		dataType{src: "4,1313,3012", expected: "12"},

		dataType{src: "10,123,4567", expected: "65"},
		dataType{src: "7,123,4560", expected: "52"},
		dataType{src: "19,123,abcd", expected: "149"},
		dataType{src: "2,1010,10101010", expected: "161"},
		dataType{src: "3,1010,10101010", expected: "240"},
	}
	for _, t := range data {
		actual := solveSlow(t.src)
		fmt.Printf("solveSlow(%q)=%q, want %q\n", t.src, actual, t.expected)
		if actual != t.expected {
			panic(t.src)
		}
	}
}

func main() {
	test()
	for i := 4; ; i++ {
		start := time.Now()
		for _, b := range []int{2, 10, 36} {
			hi := uint64(1) << uint64(i)
			shi := strconv.FormatUint(hi, b)
			src := fmt.Sprintf("%d,1,%s", b, shi)
			actual := solveSlow(src)
			fmt.Println(i, src, actual)
		}
		tick := time.Now().Sub(start).Seconds()
		fmt.Println("tick:", tick, "sec")
		fmt.Println("------------------")
		if 20 < tick {
			break
		}
	}
}
