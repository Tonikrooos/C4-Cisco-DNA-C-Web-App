import requests
import json
import time
import urllib3
from math import floor
from requests.auth import HTTPBasicAuth
import sched
import os

urllib3.disable_warnings()
url1 = 'https://sandboxdnac2.cisco.com/dna/system/api/v1/auth/token'
url2 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/network-device'
url3 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/network-health'
url4 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/site-health'
url5 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/client-health'
url6 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/topology/physical-topology'
url7 = 'https://sandboxdnac2.cisco.com/dna/intent/api/v1/discovery/count'
myusername = 'devnetuser'
mypassword = 'Cisco123!'


def get_token():
    token = requests.post(url1, auth=HTTPBasicAuth(myusername, mypassword),
                          headers={'content-type': 'application/json'},
                          verify=False,
                          )
    data1 = token.json()
    return data1['Token']


def get_devices(ticket):
    payload = ''
    newheaders = {
        'X-Auth-Token': ticket,
        'cache-control': 'no-cache'
        }
    response = requests.request('GET', url2, data=payload, headers=newheaders, verify=False)
    data2 = response.json()  # data2 为字典格式，带单引号，json.dumps(data2)为json格式，带双引号
    devices_num = len(data2['response'])
    devices = []
    # devices = {'Wireless Controller': [], 'Switches and Hubs': [], 'Unified AP': []}
    for i in range(devices_num):
        devices.append({})
    reachable_devices_num = 0
    WirelessController_num = 0
    Switches_Hubs_num = 0
    Unified_AP_num = 0
    n = 0
    for j in data2['response']:
            devices[n]['hostname'] = j['hostname']
            devices[n]['series'] = j['series']
            devices[n]['macAddress'] = j['macAddress']
            devices[n]['managementIpAddress'] = j['managementIpAddress']
            devices[n]['id'] = j['id']
            devices[n]['type'] = j['family']
            if j['reachabilityStatus'] == 'Reachable':
                reachable_devices_num += 1
            if j['family'] == 'Wireless Controller':
                WirelessController_num += 1
                # devices['Wireless Controller'].append({'hostname': str(j['hostname']), 'series': str(j['series']),
                #                                        'macAddress': str(j['macAddress']),
                #                                        'managementIpAddress': str(j['managementIpAddress']),
                #                                        'id': str(j['id']), 'type': str(j['family'])})
            if j['family'] == 'Switches and Hubs':
                Switches_Hubs_num += 1
                # devices['Switches and Hubs'].append({'hostname': str(j['hostname']), 'series': str(j['series']),
                #                                        'macAddress': str(j['macAddress']),
                #                                        'managementIpAddress': str(j['managementIpAddress']),
                #                                        'id': str(j['id']), 'type': str(j['type'])})
            if j['family'] == 'Unified AP':
                Unified_AP_num += 1
                # devices['Unified AP'].append({'hostname': str(j['hostname']), 'series': str(j['series']),
                #                                      'macAddress': str(j['macAddress']),
                #                                      'managementIpAddress': str(j['managementIpAddress']),
                #                                      'id': str(j['id']), 'type': str(j['type'])})
            n += 1
    type_num = {'total_devices_num': devices_num, 'reachable_devices_num': reachable_devices_num,
                'WirelessController_num': WirelessController_num,
                'Switches_Hubs_num': Switches_Hubs_num, 'Unified_AP_num': Unified_AP_num}
    devices_data = {'devices': devices, 'type_num': type_num}
    return devices_data


def get_timestamp():
    t = time.time()
    now_time = int(floor(t*1000))
    # print(now_time)
    return now_time


def get_network_health(ticket, params):
    payload = ''
    headers = {
        'X-Auth-Token': ticket,
        'Content-Type': "application/json",
        }
    response = requests.request('GET', url3, data=payload, headers=headers, params=params, verify=False)
    data = response.json()
    health_data = {'overall_health': {}}
    health_data['overall_health']['overall_healthScore'] = data['response'][0]['healthScore']
    health_data['overall_health']['totalCount'] = data['response'][0]['totalCount']
    health_data['overall_health']['goodCount'] = data['response'][0]['goodCount']
    health_data['overall_health']['fairCount'] = data['response'][0]['fairCount']
    health_data['overall_health']['badCount'] = data['response'][0]['badCount']
    health_data['overall_health']['timeinMillis'] = data['response'][0]['timeinMillis']
    for i in range(len(data['healthDistirubution'])):
            health_data[str(data['healthDistirubution'][i]['category'])] = {}
            health_data[str(data['healthDistirubution'][i]['category'])]['overall_healthScore'] = data['healthDistirubution'][i]['healthScore']
            health_data[str(data['healthDistirubution'][i]['category'])]['totalCount'] = data['healthDistirubution'][i]['totalCount']
            health_data[str(data['healthDistirubution'][i]['category'])]['goodCount'] = data['healthDistirubution'][i]['goodCount']
            health_data[str(data['healthDistirubution'][i]['category'])]['badCount'] = data['healthDistirubution'][i]['badCount']
            health_data[str(data['healthDistirubution'][i]['category'])]['fairCount'] = data['healthDistirubution'][i]['fairCount']
    return health_data


def get_site_health(ticket, params):
    payload = ''
    headers = {
        'X-Auth-Token': ticket,
        'Content-Type': "application/json",
        }
    response = requests.request('GET', url4, data=payload, headers=headers, params=params, verify=False)
    data = response.json()
    site_health = []
    for i in range(len(data['response'])):
        if data['response'][i]['healthyNetworkDevicePercentage'] is not None:
            site_health.append({'siteName': str(data['response'][i]['siteName']),
                                'parentSiteName': str(data['response'][i]['parentSiteName']),
                                'siteType':  str(data['response'][i]['siteType']),
                                'numberOfNetworkDevice': data['response'][i]['numberOfNetworkDevice'],
                                'healthyNetworkDevicePercentage': data['response'][i]['healthyNetworkDevicePercentage'],
                                'numberOfClients': data['response'][i]['numberOfClients'],
                                'healthyClientsPercentage': data['response'][i]['healthyClientsPercentage']})
    return site_health


def get_client_health(ticket, params):
    payload = ''
    headers = {
        'X-Auth-Token': ticket,
        'Content-Type': "application/json",
        }
    response = requests.request('GET', url5, data=payload, headers=headers, params=params, verify=False)
    data = response.json()
    client_health = {'total_data': {"scoreValue": data['response'][0]['scoreDetail'][0]["scoreValue"],
                                   "clientCount": data['response'][0]['scoreDetail'][0]["clientCount"],
                                   "clientUniqueCount": data['response'][0]['scoreDetail'][0]["clientUniqueCount"]},
                  'wired_data': {"scoreValue": data['response'][0]['scoreDetail'][1]["scoreValue"],
                                   "clientCount": data['response'][0]['scoreDetail'][1]["clientCount"],
                                   "clientUniqueCount": data['response'][0]['scoreDetail'][1]["clientUniqueCount"]},
                  'wireless_data': {"scoreValue": data['response'][0]['scoreDetail'][2]["scoreValue"],
                                      "clientCount": data['response'][0]['scoreDetail'][2]["clientCount"],
                                      "clientUniqueCount": data['response'][0]['scoreDetail'][2]["clientUniqueCount"]}}
    return client_health


def get_users(ticket):
    payload = ''
    newheaders = {
        'X-Auth-Token': ticket,
        'cache-control': 'no-cache'
    }
    # ap = []
    # host = {'wired': [], 'wireless': []}
    hosts = []
    wireless_host = 0
    wired_host = 0
    response = requests.request('GET', url6, data=payload, headers=newheaders, verify=False)
    devices_data = get_devices(ticket)['devices']
    data2 = response.json()
    for i in range(len(data2['response']['nodes'])):
        # if data2['response']['nodes'][i]['family'] == 'Unified AP':
        #     ap.append({'label': str(data2['response']['nodes'][i]['label']),
        #                'ip': str(data2['response']['nodes'][i]['ip']),
        #                'id': str(data2['response']['nodes'][i]['id'])})
        if data2['response']['nodes'][i]['role'] == 'HOST':
            hosts.append({'id': str(data2['response']['nodes'][i]['id']),
                          'ip': str(data2['response']['nodes'][i]['ip']),
                          'macaddress': str(data2['response']['nodes'][i]['additionalInfo']['macAddress'])})
            if data2['response']['nodes'][i]['deviceType'] == 'wired':
                wired_host += 1
            elif data2['response']['nodes'][i]['deviceType'] == 'wireless':
                wireless_host += 1
    for j in range(len(devices_data)):
        devices_data[j]['link'] = []
    for i in range(len(data2['response']['links'])):
        for j in range(len(devices_data)):
            if devices_data[j]['id'] == data2['response']['links'][i]['source']:
                for k in range(len(hosts)):
                    if hosts[k]['id'] == data2['response']['links'][i]['target']:
                        devices_data[j]['link'].append(hosts[k])
                # for m in range(len(devices_data)):
                #     if devices_data[m]['id'] == data2['response']['links'][i]['target']:
                #         devices_data[j]['link'].append({'id': devices_data[m]['id'],
                #                                         'ip': devices_data[m]['managementIpAddress'],
                #                                         'macaddress': devices_data[m]['macAddress']})
                #         devices_data[m]['link'].append({'id': devices_data[j]['id'],
                #                                         'ip': devices_data[j]['managementIpAddress'],
                #                                         'macaddress': devices_data[j]['macAddress']})
    data = [{'wired_host_num': wired_host, 'wireless_host_num': wireless_host}]
    for i in range(len(devices_data)):
        if devices_data[i]['link']:
            data.append(devices_data[i])
    return data


def get_flow_analysis(ticket):
    payload = ''
    headers = {
        'X-Auth-Token': ticket,
        'Content-Type': "application/json",
    }
    response = requests.request("GET", url5, data=payload, headers=headers, verify=False)
    data = response.json()
    flow_id = []
    for i in range(len(data['response'])):
        flow_id.append(data['response'][i]['id'])
    print(json.dumps(data, indent=4, separators=(',', ':')))
    return flow_id


# get_timestamp()
token = get_token()
params = {'timestamp': str(get_timestamp())}
devices_data = get_devices(token)
devices_health_data = get_network_health(token, params)
devices_data['devices_health_data'] = devices_health_data
client_health = get_client_health(token, params)
devices_data['client_health'] = client_health
site_health = get_site_health(token, params)
devices_data['site_health'] = site_health
host_data = get_users(token)
devices_data['host_data'] = host_data
print(json.dumps(devices_data, indent=4, separators=(',', ':')))

# s = sched.scheduler(time.time, time.sleep)
#
#
# # 被周期性调度触发的函数
# def event_func(data):
#     token = get_token()
#     devices_data = get_devices(token)
#     devices_health_data = get_network_health(token)
#     host_data = get_users(token)
#     devices_data['devices_health_data'] = devices_health_data
#     devices_data['host_data'] = host_data
#     data.append(devices_data)
#     print(data, file=open('data.txt', 'a'))
#
#
# def perform(inc):
#     s.enter(inc, 0, perform, (inc,))
#     event_func(data=[])
#
#
# def mymain(inc=900):
#     s.enter(0, 0, perform, (inc,))
#     s.run()
#
#
# if __name__ == '__main__':
#     mymain()
