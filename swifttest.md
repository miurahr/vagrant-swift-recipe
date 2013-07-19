By vagrant user:

add 2 lines to your .bashrc
```
export SWIFT_TEST_CONFIG_FILE=/etc/swift/test.conf
export PATH=${PATH}:/usr/local/bin
```

```
. ~/.bashrc
remakerings
cp ~/swift/test/sample.conf /etc/swift/test.conf
~/swift/.unittests
```
The Unable to increase file descriptor limit.
Running as non-root? warnings are expected and ok.

```
startmain
```

Get an X-Storage-Url and X-Auth-Token: 
```
curl -v -H 'X-Storage-User: test:tester' -H 'X-Storage-Pass: testing' http://127.0.0.1:8080/auth/v1.0
```

Check that you can GET account: 
```
curl -v -H 'X-Auth-Token: <token-from-x-auth-token-above>' <url-from-x-storage-url-above>
```

Check that swift works: 
```
swift -A http://127.0.0.1:8080/auth/v1.0 -U test:tester -K testing stat
```

get git repository and swift test
```
cd ~/
git clone https://github.com/openstack/python-swiftclient.git
git clone https://github.com/openstack/swift.git 
cd ~/swift
sudo pip install -r swift/test-requirements.txt
```

Run tests.
```
~/swift/.functests
# (Note: functional tests will first delete everything in the configured accounts.)
~/swift/.probetests
# (Note: probe tests will reset your environment as they call resetswift for each test.)
```
