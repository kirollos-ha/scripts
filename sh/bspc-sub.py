#! /usr/bin/python3

def parse_report(report):
    return { "current" : report_get_current_workspace(report),
             "occupied" : report_get_occupied_workspaces(report) }

def print_parsed(parsed):
    print("{\"curr\":" + parsed['current'] + "\",\"occupied\":[",end='')

    n = len(parsed['occupied'])
    [print("\""+i+"\",",end='') for i in parsed['occupied'][0:n-1]]
    print("\""+parsed['occupied'][n-1]+"\"",end='')
    print("]}")

def report_get_current_workspace(report):
    for ws in report.split(':')[1:]:
        if ws[0].isupper():
            return ws[1:]
    return ""

def report_get_occupied_workspaces(report):
    res = []
    for ws in report.split(':')[1:]:
        if ws[0].lower() == 'o':
            res.append(ws[1:])
    return res

if __name__=="__main__":
    while True:
        s = input()
        print(parse_report(s))
        print_parsed(parse_report(s))
