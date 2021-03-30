#!/usr/bin/python3

import subprocess, os, sys
argv = sys.argv[1:]

helpMsg = "Syntax: hamd [cmd] [.deb package name]\n\nAvailable cmd:\tdown, depends, --errors, help, iarcp, update"
try:    cmd = argv[0]
except IndexError:  exit("hamd: No command specified.")
errorCmd = ' | grep -v "^ " | grep -v "^debconf-2.0$" '
if len(argv) > 2: 
    errors = argv[-1].split("_")
    for error in errors:
        errorCmd += '| grep -v "^' + error + '$" '





installedDir = "/mnt/security/layer/hamd/os/final/pkg/.pkg/installed"
installed = open(installedDir, "r").read().split("\n")
try: 
    pkg = argv[1]
    
    dependsCmd = 'apt-rdepends '+pkg+errorCmd
    depends = subprocess.getoutput(dependsCmd); 
    depends = depends[depends.index(pkg):].split("\n")
    dependsString = ""

    for i in range(len(depends)):
        matched = False
        for j in range(len(installed)):
            if installed[j] != "" and depends[i] == installed[j][:installed[j].index("_")]:
                #print("I matched:"+depends[i])
                matched = True
                break  #intentionally kept not-smart
        if matched == False: 
            print("Didn't match: "+depends[i]); dependsString += " "+depends[i]
        
    depends=dependsString
    if len(depends) == 0: exit("\nThe package is installed completely.")
    depends = depends[1:]
    print("\n\n")
except IndexError: print("No package specified / only --errors specified\n\n")





if cmd == "help": 
    #print('Pre-requisites: `apt-rdepends <pkg> |grep -v "^ " |grep -v "^debconf-2.0$"`')
    print(helpMsg)

elif cmd == "down": 
    download = 'apt-get download '+depends
    os.system(download)
    os.system("echo '"+"_* ".join(depends.split(" ")[::-1])+"_*' > installing_packages")
    print("\n\nDont't forget to `sudo hamd update`... Sorted script for dpkg -i generated.")


elif cmd == "update":
    ls = subprocess.getoutput("ls *.deb")
    updateString = "\n\n"
    for i in ls.split("\n"): 
        if i not in installed: updateString += '\n'+i
    if updateString != '\n\n':
        updateCmd = "echo '"+updateString+"'>> "+installedDir
        os.system(updateCmd)
        print("Installed package list updated.")
    elif updateString == '\n\n': print("Current directory is already updated")

elif cmd == "arcp":
    deps = depends
    
    for i in deps[::-1]:
        deb = i+'_*.deb'
        mkdirSuccess =  os.system("mkdir "+i+" > /dev/null 2>&1")
        if mkdirSuccess == 0:
            os.chdir(i); os.system("ar x ../"+deb+"; tar xf data*") #data.tar.xz / .gz
        
            dests = [f.path for f in os.scandir(".") if f.is_dir()]
            for d in dests:
                d = d[2:]
                copy = "sudo cp -n -r "+d+"/* ../../"+d
                os.system(copy)
            os.chdir("../") 
        elif mkdirSuccess != 0: print("Dependency: "+deb+" already met. Skipping copy.")

elif cmd == "depends":
    for i in depends.split(" "): print(i)
else: exit(helpMsg)
