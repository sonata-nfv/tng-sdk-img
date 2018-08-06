import yaml,sys

def print_mgmt_cp():
    vnfd = yaml.safe_load(sys.stdin)

    vnf_mgmt_cp = ""
    for cp in vnfd["connection_points"]:
        if cp["type"] == "management":
            vnf_mgmt_cp = cp["id"]

    if not vnf_mgmt_cp:
        return ""

    for vl in vnfd["virtual_links"]:
        points = vl["connection_points_reference"]
        try:
            points.remove(vnf_mgmt_cp)
            print ' '.join(points[0].split(":"))
        except:
            continue

if __name__ == "__main__":
    print_mgmt_cp()

