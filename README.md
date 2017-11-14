## StackStorm Auto Remedial Stack

This stack allows you to impliment auto remdiation on your infrastructure.

## Pre-Requisite
Before using this stack you need to have below things already in your infrastructure.

* #### For Public Cloud (AWS)
	##### Public cloud recovery flow
		Process(Down) -> CloudWatch -> SNS -> SQS -> StackStrom -> Rundeck
        StackStrom(NoAction) <- SQS <- SNS <- CloudWatch <- Process(Up) <- Rundeck

	* AWS envirnoment being monitoered by CloudWatch
	* Cloudwatch alerts needs to be enable to send notification on SNS topic
	* SNS topic should be subscribe with SQS
	* *Most Important* Your alert name should be match from the below pattern
      
      `MON_<Project>_<Module>_<NameSpace>_<Metric>_<Hostname>`
      
* #### For Private Cloud (OpenStack/VMware)
	* Envirnoment being monitoered by Prometheus
	* Prometheus alerts needs to be enable to send notification on Alertmanager then Alerta
	* Alertashould be sending alerts to RabbitMQ

### Installation

 * #### Installing and Configuring stack for Public Cloud (AWS)
 
	* Configuring/Installing StackStorm
	
			Use below link to install StackStrom on your infrastructure
			https://docs.stackstorm.com/install/index.html
			
	* Configuring/Installing StackStorm Packs
		
			After Installation use st2 utility to install required packs
			st2 pack install aws
			st2 pack config aws
			enter your AWS cred's and queue name
			git clone https://github.com/GloballogicPractices/GLAuto-Remedial-Stack.git
			st2 rule add -f GLAuto-Remedial-Stack/stackstrom/rules/remedy.yaml
			st2 rule add -f GLAuto-Remedial-Stack/stackstrom/rules/summary.yaml	
				
	* Installing RunDeck/CLI

			Use below link to install RunDeck
				http://rundeck.org/docs/administration/installation.html
				
			Use below link to install RunDeck Cli
				https://github.com/rundeck/rundeck-cli
			
	* Configure RunDeck

		* Create new project
		* Create job and add [rundeck/process.sh](process.sh) into it 
			

	* Installing Redmine
		
			Use below link to install Redmine
				http://www.redmine.org/projects/redmine/wiki/How_to_Install_Redmine_on_CentOS_(Detailed)
				
	* CloudWatch Plugins

		* You can use your own CloudWatch plugins for this stack
		* Make sure that Alert name should be in the above mentioned format.
	
	
 
 * #### Installing and Configuring stack for Private Cloud (OpenStack)
 
	* Configuring/Installing StackStorm  - Same as public cloud
			
	* Configuring/Installing StackStorm Packs
		
			After Installation use st2 utility to install required packs
			st2 pack install rabbitmq
			st2 pack config rabbitmq
			enter your cred's and queue name
			git clone https://github.com/GloballogicPractices/GLAuto-Remedial-Stack.git
			st2 rule add -f GLAuto-Remedial-Stack/stackstrom/rules/priv-remedy.yaml
			st2 rule add -f GLAuto-Remedial-Stack/stackstrom/rules/summary.yaml	
				
	* Installing RunDeck/CLI - Same as public cloud
			
	* Configure RunDeck - Same as public cloud

	* Installing Redmine - Same as public cloud
					
	* Installing RabbiMQ

			Use below link to install RabbitMQ
				https://www.rabbitmq.com/install-rpm.html
		
	* Installing Prometheus

			Use below link to install Prometheus
				https://prometheus.io/docs/prometheus/latest/installation/
			
	* Installing Alerta

			Alerta installation
				http://alerta.readthedocs.io/en/latest/quick-start.html
				https://github.com/alerta/alerta-contrib/tree/master/plugins/amqp
			
	* Prometheus Plugins
		* You can use official prometheus plugin
		* Or use metrics.sh for customize plugin
		
