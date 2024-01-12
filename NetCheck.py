from os import system
import subprocess, os, time, datetime, ctypes, csv

# open initconifg.csv file and get initial config for ping test and traceroute
with open('initconfig.csv') as csvfile:
        readCSV = csv.reader(csvfile, delimiter=',')
        initConf = list(readCSV)
        initTrace = []
        initPing = []
        iCntr = 0
        for iConfig in initConf:
            if iCntr == 0:
                iCntr += 1
                continue
            elif iCntr == 1:
                initPing = iConfig[1:3]
                initPing.append(iConfig[4])
                iCntr += 1
            elif iCntr == 2:
                initTrace = iConfig[2:5]

pingSwitch = ' -n ' + str(initPing[0]) + ' -w ' + initPing[1]
pingTimeOut = int(initPing[2])  
traceSwitch = ' -h ' + str(initTrace[1]) + ' -w ' + initTrace[0] + ' '
traceTimeOut = int(initTrace[2])          

# open ext-conf.csv file and get host/address list for ping test and trace route
with open('ext-conf.csv') as csvfile:
        readCSV = csv.reader(csvfile, delimiter=',')
        extConf = list(readCSV)
        extCntr = 0
        extName = []
        extAddress = []
        for extSite in extConf:
            ## Check for any blank fields or column and skip it
            if extSite[0] == '' or extSite[1] == '':
                continue
            extName.append(extSite[0])
            extAddress.append(extSite[1])
            extCntr += 1

myTime = datetime.datetime.now()
print('=========================')
print('|     NetCheck beta     |')
print('|     by fR0z3byte      |')
print('=========================\n\n')
print('NetCheck will now perform external and internal network tests. Please wait....\n\n')

# Perform External ping and trace route
def PingTracert(testType, nodeName, nodeAddress, counter):

    file_ = open(testType + '-ping-traceroute.' + myTime.strftime('%Y.%m.%d.%H.%M.%S') + '.txt', 'w+') 
    subprocess.Popen('echo ************************************************', shell=True, stdout=file_)
    time.sleep(1)
    subprocess.Popen('echo *          ' + testType + ' Ping Test Result           *', shell=True, stdout=file_) 
    time.sleep(1)
    subprocess.Popen('echo ************************************************', shell=True, stdout=file_)
    subprocess.Popen('echo.', shell=True, stdout=file_)
    subprocess.Popen('echo.', shell=True, stdout=file_)
    time.sleep(1)
    i = 0
    while i <= counter:
        print('--->Performing ' + testType + ' Network Test to: ' + nodeName[i], ' - ', nodeAddress[i], '\nRunning Ping Test....',end="")
        print()
        time.sleep(2)
        subprocess.Popen('echo =================================', shell=True, stdout=file_)
        time.sleep(1)
        subprocess.Popen('echo Ping Test to ' + nodeName[i], shell=True, stdout=file_)
        time.sleep(1)
        subprocess.Popen('echo =================================', shell=True, stdout=file_)
        time.sleep(1)
        
        subprocess.Popen('ping ' + nodeAddress[i] + pingSwitch, shell=True, stdout=file_) 
        time.sleep(pingTimeOut)
        print('Completed', '\nRunning Trace Route Test....',end="")
        subprocess.Popen('echo.', shell=True, stdout=file_)
        subprocess.Popen('echo.', shell=True, stdout=file_)  
        time.sleep(1)
        subprocess.Popen('echo ======================================', shell=True, stdout=file_)
        time.sleep(1)
        subprocess.Popen('echo Trace Route Test to ' + nodeName[i], shell=True, stdout=file_)
        time.sleep(1)
        subprocess.Popen('echo ======================================', shell=True, stdout=file_)
        print()
        time.sleep(1)
        subprocess.Popen('tracert ' + traceSwitch + nodeAddress[i], shell=True, stdout=file_) 
        time.sleep(traceTimeOut)
        print('Completed')
        subprocess.Popen('echo.', shell=True, stdout=file_)
        subprocess.Popen('echo.', shell=True, stdout=file_)  
        
        time.sleep(1)
        i += 1
    
PingTracert('External', extName, extAddress, (extCntr-1))

# open int-conf.csv file and get initial config for ping test and traceroute
with open('int-conf.csv') as csvfile:
        readCSV = csv.reader(csvfile, delimiter=',')
        intConf = list(readCSV)
        intCntr = 0
        intName = []
        intAddress = []
        for intSite in intConf:
            ## Check for any blank fields or column and skip it
            if intSite[0] == '' or intSite[1] == '':
                continue
            intName.append(intSite[0])
            intAddress.append(intSite[1])
            intCntr += 1

PingTracert('Internal', intName, intAddress, (intCntr-1))

print('\nFinalizing: Retrieving host network configuration....')

file_2 = open('Endpoint-NetworkConfiguration.' + myTime.strftime('%Y.%m.%d.%H.%M.%S') + '.txt', 'w+')
subprocess.Popen('echo *****************************************************', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo *           Endpoint Network Configuration          *', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo *****************************************************', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo. && echo.', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo ***********************************', shell=True, stdout=file_2)
time.sleep(1)
subprocess.Popen('echo *           ipconfig/all          *', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo ***********************************', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('ipconfig/all', shell=True, stdout=file_2)
time.sleep(10)
subprocess.Popen('echo ******************************************************', shell=True, stdout=file_2)
time.sleep(1)
subprocess.Popen('echo *           Wireless Network Adapter Config          *', shell=True, stdout=file_2) 
time.sleep(1)
subprocess.Popen('echo ******************************************************', shell=True, stdout=file_2)
time.sleep(1)
subprocess.Popen('wmic NIC where \"NetEnabled=\'true\'\" get \"Name\",\"Speed\"', shell=True, stdout=file_2)
subprocess.Popen('netsh wlan show interfaces', shell=True, stdout=file_2)
time.sleep(3)
subprocess.Popen('netsh wlan show profiles', shell=True, stdout=file_2)
time.sleep(3)
subprocess.Popen('netsh wlan show settings', shell=True, stdout=file_2)
file_2.close()

print('\nTest completed.\n')
print(""" Please send the following files to IT Admin for assessment and troubleshooting:
- Endpoint-NetworkConfiguration.<date/time>.txt
- External-ping-traceroute.<date/time>.txt
- Internal-ping-traceroute.<date/time>.txt 
email to: test@test.com; test@test.com\n
""")

system('pause')