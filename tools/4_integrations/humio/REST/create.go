package main

import (
	"fmt"
	"io/ioutil"
	"net/http"
)

func sendHumioGetNotifiers() {
	// HUMIO GET NOTIFIERS (GET http://humio-humio-logging.aiops-a376efc1170b9b8ace6422196c51e491-0000.par01.containers.appdomain.cloud/api/v1/repositories/aiops/alertnotifiers)

	// Create client
	client := &http.Client{}

	// Create request
	req, err := http.NewRequest("GET", "http://humio-humio-logging.aiops-a376efc1170b9b8ace6422196c51e491-0000.par01.containers.appdomain.cloud/api/v1/repositories/aiops/alertnotifiers", nil)

	// Headers
	req.Header.Add("Content-Type", "application/json")
	req.Header.Add("Authorization", "Bearer svTejl36u9LXWlzHA8DBExKEjyrZOlWW3ul52JedMtYz")
	req.Header.Add("Cookie", "5aeaa98598eb11937cc50f57efd7ab5b=2f04ddcffebab6cce361fe37ec1edcb6")

	// Fetch Request
	resp, err := client.Do(req)
	
	if err != nil {
		fmt.Println("Failure : ", err)
	}

	// Read Response Body
	respBody, _ := ioutil.ReadAll(resp.Body)

	// Display Results
	fmt.Println("response Status : ", resp.Status)
	fmt.Println("response Headers : ", resp.Header)
	fmt.Println("response Body : ", string(respBody))
}


func main(){
	sendHumioGetNotifiers()
}