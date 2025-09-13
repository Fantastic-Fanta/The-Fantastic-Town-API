import requests
def FetchData(CODE: str) -> dict:
    URL = f"http://apis.valencel.com/bt/export/{CODE.lower()}" #main endpoint
    Headers = {
        "bv-userid": "000000", #Never tested if there's a ratelimit on a specific user id, but just round robin / random gen to bypass if needed
        "bv-productid": "BVProj.Valencel.BTWebService.ExportImportPlugin @1.8.0", #Update {@1.8.0} to current version id if buildverse doesn't want you to use outdated versions
        "bv-productkey": "0000" 
    }
    try:
        Res = requests.get(URL, headers=Headers)
        ResJson = Res.json()
    except requests.RequestException as e:
        print("Failure:",e)
    return ResJson
