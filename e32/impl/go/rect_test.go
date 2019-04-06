package main

// `go test -args data.json` で実行する

import (
	"encoding/json"
	"io/ioutil"
	"log"
	"os"
	"testing"
)

func TestAll(t *testing.T) {
	var data map[string]interface{}
	jsonBytes, err := ioutil.ReadFile(os.Args[1])
	if err != nil {
		log.Fatal(err)
	}
	json.Unmarshal(jsonBytes, &data)
	failCount := 0
	for _, item := range data["test_data"].([]interface{}) {
		i := item.(map[string]interface{})
		e := i["expected"].(string)
		s := i["src"].(string)
		a := solve(s)
		ok := e == a
		if !ok {
			t.Errorf("solve(%s) is %s, want %s", s, a, e)
		}
	}
	log.Println("Fail Count:", failCount)
}
