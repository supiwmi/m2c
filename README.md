# m2c

> ssh-keygen
> cat /home/suparuek/.ssh/id_rsa.pub

Then copy into https://github.com/supiwmi

once complete you should be able to pull the code from https://github.com/supiwmi/m2c from gitlabdocker.southeastasia.cloudapp.azure.com server

> git pull git@github.com:supiwmi/m2c.git

# How to backup and Restore Gitlab

> grep backup_path /etc/gitlab/gitlab.rb

# Application Backup
To actually take the application backup, run the following.
> gitlab-rake gitlab:backup:create
> ls -ltrh /var/opt/gitlab/backups/

# Transfer
Lets zip and compress these files into a single archive for transfer. Although I don’t plan on restoring the host keys, here I zip and compress all three all the same.

> cd ~
> tar -cvzf ~/gitlab-backup.tar.gz /var/opt/gitlab/backups/{xxxx_04_27_11.10.1_gitlab_backup.tar,etc-gitlab-1556371986.tar,hostkeys-1556372488.tar}


> ssh root@192.168.56.111

Use scp to copy the backup securely over the internet. Here I run the below from the new GitLab server to pull the above backup to the current working directory.

> scp -v root@192.168.56.112:/root/gitlab-backup.tar.gz .

If you’d rather push it from the old server to the new, the command would be:

> scp -v gitlab-backup.tar.gz root@192.168.56.112:/root/

# Restore
As I am mainly concerned about the Git repositories themselves, I will only be doing an application restore.
If you are moving to a new host with the same hostname etc., you should also restore the configuration backup to /etc/gitlab/. If you want everything to be the same but the hostname is different, you can manually amend anything such as external_url before running sudo gitlab-ctl reconfigure.


# Extract the Restore

From the new GitLab host, as root, create the restore files.

```
mkdir gitlab-restore
mv gitlab-backup.tar.gz gitlab-restore/
cd gitlab-restore/
tar -xzvf gitlab-backup.tar.gz
ls -l
```

Application Backup Restore @<new gitlab server>

```
gitlab-ctl stop unicorn
gitlab-ctl stop sidekiq
gitlab-ctl status
```

Check they’re actually down.

> <mark>gitlab-ctl status | grep ^down</mark>

Move the application backup to the backups directory as defined in gitlab.rb and correct the owner if necessary.

> <mark>cp -v var/opt/gitlab/backups/1556372352_2019_04_27_11.10.1_gitlab_backup.tar /var/opt/gitlab/backups/</mark>

> <mark>chown -v git:git /var/opt/gitlab/backups/1556372352_2019_04_27_11.10.1_gitlab_backup.tar</mark>

Then restore. The restore name is the same as the above file name but without the <mark>_gitlab_backup.tar</mark> bit.

> <mark>gitlab-rake gitlab:backup:restore BACKUP=1556372352_2019_04_27_11.10.1</mark>

Now restart GitLab.
> <mark>gitlab-ctl start</mark>

And check for problems.
> <mark>gitlab-rake gitlab:check SANITIZE=true</mark>

If all was successful, you should be able to log into the new site as before with whatever users you had setup. 
