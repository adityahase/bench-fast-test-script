
# Usage : ssh root@139.59.80.103 "su frappe -c 'bash /home/frappe/fast.sh aditya 2 branch'"
# Goto user dierctory
cd /home/frappe/$1/
# Extinction is near.
rm -rf *
# Clone develop branch of bench repo 
git clone https://github.com/adityahase/bench --depth=1 -b develop bench-repo
# Create new virtualenv
virtualenv -p python$2 $2 && source $2/bin/activate && pip install -e bench-repo
# Run bench init with frappe repo (develop branch) and log output
bench init b --verbose --frappe-path="https://github.com/adityahase/frappe" --frappe-branch=$3 2>&1 | tee log.log
cat log.log | nc termbin.com 9999 | sed -e "s/^/$1 $(date -R) /" >> /home/frappe/log.link
tail -1 /home/frappe/log.link
