package main

import (
	"encoding/json"
	"io/ioutil"
	"net/http"

	"github.com/julienschmidt/httprouter"
)

var (
	content string
)

func init() {
	bytesRead, err := ioutil.ReadFile("response.json")
	if err != nil {
		panic(err)
	}
	content = string(bytesRead)
}

func Index(res http.ResponseWriter, req *http.Request, _ httprouter.Params) {
	bytesSerialized, err := json.Marshal(content)
	res.Header().Set("Content-Type", "application/json")
	if err != nil {
		http.Error(res, err.Error(), http.StatusInternalServerError)
		return
	}
	_, err = res.Write(bytesSerialized)
	if err != nil {
		http.Error(res, err.Error(), http.StatusInternalServerError)
		return
	}
}

func main() {
	router := httprouter.New()
	router.GET("/", Index)
	http.ListenAndServe(":5000", router)
}
