import os

import testinfra.utils.ansible_runner

testinfra_hosts = testinfra.utils.ansible_runner.AnsibleRunner(
    os.environ['MOLECULE_INVENTORY_FILE']).get_hosts('all')


def test_hosts_file(host):
    f = host.file('/etc/hosts')

    assert f.exists
    assert f.user == 'root'
    assert f.group == 'root'

# check if MongoDB is enabled and running
def test_mongo_running_and_enabled(host):
	mongo = host.service("mongod")
	assert mongo.is_running
	assert mongo.is_enabled
    
# check if configuration file contains the required line
def tets_config_file(File):
	config_file = host.file('etc/mongod.conf')
	assert config_file.contains('bindIp: 0.0.0.0')
	assert config_file.is_file

# check if MongoDB is listening to port
def test_mongo_listening_port(host):
	mongoport = host.socket("tcp://0.0.0.0:27017")
	assert mongoport.is_listening
        

