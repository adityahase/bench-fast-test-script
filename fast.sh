
# Usage : ssh root@139.59.80.103 "su frappe -c 'bash /home/frappe/fast.sh aditya 2 frappe-branch bench-branch'"
# Goto user dierctory
cd /home/frappe/$1/
# Extinction is near.
rm -rf *
# Clone develop branch of bench repo 
git clone https://github.com/adityahase/bench --depth=1 -b $4 bench-repo
# Create new virtualenv
virtualenv -p python$2 $2 && source $2/bin/activate && pip install -e bench-repo
# Run bench init with frappe repo (develop branch) and log output
bench init b --verbose --frappe-path="https://github.com/adityahase/frappe" --frappe-branch=$3 2>&1 | tee log.log
cat log.log | python -c 'import json,sys; print(json.dumps(dict([("contents",sys.stdin.read())])))' > log.json
curl -X POST -d @log.json -H "Content-Type: application/json" https://paste.fedoraproject.org/api/paste/submit | jq -r ".url" > log.url
cat log.url | sed -e "s/^/$1 $(date -R) /" >> /home/frappe/log.link
tail -1 /home/frappe/log.link
