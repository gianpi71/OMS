import json
from datetime import datetime

import requests
from requests.utils import requote_uri

now = datetime.now()
orderId = now.strftime('%Y-%m-%d %H:%M:%S')

json_data = {}

json_data['orderId'] = orderId
json_data['secretKey'] = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
json_data['qty'] = 1.0
json_data['ordType'] = "LIMIT"
json_data['side'] = "SELL"
json_data['price'] = 99
json_data['timeInForce'] = "IC"

parties = {}
parties["account"] = "BT"
parties["executor"] = "U392334"
parties["investor"] = "U392334"

json_data['parties'] = parties

instrument = {}
instrument["symbol"] = "I"
instrument["securityExchange"] = "ICE-LIFFE"
instrument["securityType"] = "FUT"
instrument["maturityMonthYear"] = "202612"
# instrument["strikePrice"] =
# instrument["payoff"] = "CALL"

json_data['instrument'] = instrument

url = "http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/U0I7391/fastfill/orders/createSimple"

headers = {"Content-type": "application/json"}
response = requests.post(url, json=json_data, headers=headers)
# print(json.dumps(response.json(), indent=4))

url_status = "http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/U0I7391/fastfill/status/" + orderId
print(json.dumps(requests.get(requote_uri(url_status)).json(), indent=4))

# url_history = "http://dma-rest-res10-svia.cloudfinanza-svil.intesasanpaolo.com/U0I7391/fastfill/history/" + orderId
# print(json.dumps(requests.get(requote_uri(url_history)).json(), indent=4))
