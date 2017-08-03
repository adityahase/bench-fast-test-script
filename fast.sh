
# Usage : ssh root@139.59.80.103 "su frappe -c 'bash /home/frappe/fast.sh aditya 2 frappe-branch bench-branch'"
# Goto user dierctory
cd /home/frappe/$1/
# Remove Everything
rm -rf *
#Create and CD to a random directory
dir=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)
mkdir $dir && cd $dir
# Clone develop branch of bench repo 
git clone https://github.com/adityahase/bench --depth=1 -b $4 bench-repo >> log.log
# Create new virtualenv
virtualenv -p python$2 $2 && source $2/bin/activate && pip install -e bench-repo >> log.log
# Run bench init with frappe repo (develop branch) and log output
# Set .cache as npm cache dir
npm config set cache .cache
echo "user : $1 pythonversion : $2 frappe-branch $3 bench-branch : $4 dir : $dir" >> log.log
mkdir sites
echo '{"shallow_clone":true}' > /sites/common_site_config.json
bench init b --verbose --frappe-path="https://github.com/adityahase/frappe" --frappe-branch=$3 2>&1 | tee -a log.log
# Read command log and write to a p.f.org compatible json file
cat log.log | python -c 'import json,sys; print(json.dumps({"expiry_time":"1609372800", "contents":sys.stdin.read()}))' > log.json
# Copy log to p.f.org and note url
curl -X POST -d @log.json -H "Content-Type: application/json" https://paste.fedoraproject.org/api/paste/submit | jq -r ".url" > log.url
# Log URL in link file
cat log.url | sed -e "s/^/$1 $(date -R) /" >> /home/frappe/log.link
# Print last url entry
tail -1 /home/frappe/log.link
