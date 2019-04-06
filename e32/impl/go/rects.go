package main

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"log"
	"os"
	"sort"
	"strconv"
	"strings"
)

const n = 0x1000
const wh = 36

type rectType struct {
	x, y, r, b int
}

func (r *rectType) size() int {
	return (r.r - r.x) * (r.b - r.y)
}

func mustAtoi(s string) int {
	i, err := strconv.ParseInt(s, 36, 32)
	if err != nil {
		log.Fatalln(err)
	}
	return int(i)
}

func createRect(s string) rectType {
	return rectType{
		x: mustAtoi(s[0:1]),
		y: mustAtoi(s[1:2]),
		r: mustAtoi(s[2:3]),
		b: mustAtoi(s[3:4]),
	}
}

func makeField(rects []rectType) map[int]int {
	f := map[int]int{}
	for ix, r := range rects {
		for y := r.y; y < r.b; y++ {
			for x := r.x; x < r.r; x++ {
				f[y*n+x] += (1 << uint(ix))
			}
		}
	}
	return f
}

func findRight(field map[int]int, x0, y0 int) int {
	val0 := field[x0+y0*n]
	for x := x0; x < wh+1; x++ {
		if val0 != field[x+y0*n] {
			return x
		}
	}
	return -1
}

func findBottom(field map[int]int, x0, y0 int) int {
	val0 := field[x0+y0*n]
	for y := y0; y < wh+1; y++ {
		if val0 != field[x0+y*n] {
			return y
		}
	}
	return -1
}

func hborder(field map[int]int, x0, x1, y0, y1 int) bool {
	val := field[y0*n+x0]
	for x := x0; x < x1; x++ {
		if field[y0*n+x] != val || field[y1*n+x] == val {
			return false
		}
	}
	return true
}

func vborder(field map[int]int, y0, y1, x0, x1 int) bool {
	val := field[y0*n+x0]
	for y := y0; y < y1; y++ {
		if field[y*n+x0] != val || field[y*n+x1] == val {
			return false
		}
	}
	return true
}
func samecol(field map[int]int, x0, y0, r, b int) bool {
	col := field[y0*n+x0]
	for y := y0; y < b; y++ {
		for x := x0; x < r; x++ {
			if col != field[y*n+x] {
				return false
			}
		}
	}
	return true
}

func isCleanRect(field map[int]int, x, y, r, b int) bool {
	if r <= x || b <= y {
		return false
	}
	return hborder(field, x, r, y, y-1) &&
		hborder(field, x, r, b-1, b) &&
		vborder(field, y, b, x, x-1) &&
		vborder(field, y, b, r-1, r) &&
		samecol(field, x, y, r, b)
}

func getRect(field map[int]int, x, y int) *rectType {
	r := findRight(field, x, y)
	b := findBottom(field, x, y)
	if isCleanRect(field, x, y, r, b) {
		return &rectType{x, y, r, b}
	}
	return nil
}

func solveImpl(rects []rectType) []rectType {
	fields := makeField(rects)
	res := []rectType{}
	for y := 0; y < wh; y++ {
		for x := 0; x < wh; x++ {
			rect := getRect(fields, x, y)
			if rect != nil {
				res = append(res, *rect)
			}
		}
	}
	return res
}

func solve(src string) string {
	srects := strings.Split(src, "/")
	rects := []rectType{}
	for _, s := range srects {
		rects = append(rects, createRect(s))
	}
	sizes := []int{}
	for _, r := range solveImpl(rects) {
		sizes = append(sizes, r.size())
	}
	sort.Ints(sizes)
	ssizes := []string{}
	for _, size := range sizes {
		ssizes = append(ssizes, fmt.Sprintf("%d", size))
	}
	return strings.Join(ssizes, ",")
}

func main() {
	var data map[string]interface{}
	jsonBytes, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	json.Unmarshal(jsonBytes, &data)
	for _, item := range data["test_data"].([]interface{}) {
		i := item.(map[string]interface{})
		e := i["expected"].(string)
		s := i["src"].(string)
		a := solve(s)
		ok := e == a
		if ok {
			log.Println("ok", s, e)
		} else {
			log.Println("**NG**", s, a, e)
		}
	}
}
