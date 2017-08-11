# Usage : ssh root@139.59.80.103 "su frappe -c 'bash /home/frappe/really_fast.sh aditya 2 frappe-branch bench-branch'"
# Getting Variables
cd ~/$1/
dir = $(ls)
p_random=$(cat /dev/urandom | tr -cd 'a-f0-9' | head -c 8)

# Goto bench-repo dierctory
cd ~/$1/$dir/bench-repo

# Delete Branch
git branch -D $4
# Create the branch again
git checkout -b $4
# pull from repo
git pull --rebase upstream $4 >> log.log

# Goto bench-repo dierctory
cd ~/$1/$dir/b/apps/frappe

# Delete Branch
git branch -D $3
# Create the branch again
git checkout -b $3
# pull from repo
git pull --rebase upstream $3 >> log.log

# Activate new virtualenv
source ~/$1/$dir/$2/bin/activate

# Log stuff
echo "SITE TEST user : $1 pythonversion : $2 frappe-branch $3 bench-branch : $4 dir : $dir" >> log.log

# cd to bench dir b
cd ~/$1/$dir/b

# run bench start log everything
bench start 2>&1 | tee -a ../log.log
# Copy log file to log directory
mv ../log.log /home/frappe/log/$p_random.log
# Append log file path in link file
echo $p_random | sed -e "s/^/$1 $(date -R) /" >> /home/frappe/log.link
# Print last url entry
tail -1 /home/frappe/log.link
