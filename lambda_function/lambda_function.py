import boto3
import logging
import os

ec2 = boto3.client('ec2')
sns = boto3.client('sns')
logger = logging.getLogger()
logger.setLevel(logging.INFO)

def lambda_handler(event, context):
    EC2_INSTANCE_ID = os.environ.get("EC2_INSTANCE_ID")
    SNS_ARN = os.environ.get("SNS_ARN")

    try:

        logger.info('Attempting to start EC2 instance %s' % EC2_INSTANCE_ID)
        ec2.reboot_instances(InstanceIds=[EC2_INSTANCE_ID])

        logger.info('Rebooting initiated. Sending notification via SNS topic %s' % SNS_ARN)
        sns.publish(
            TopicArn=SNS_ARN,
            Message='EC2 Instance %s is being rebooted' % EC2_INSTANCE_ID,
            Subject='EC2 Reboot Started'
        )
        logger.info('Process completed successfully')

        return {'status': 'success', 'rebooted':EC2_INSTANCE_ID}
        
    except Exception as e:
        logger.error('Failed to start EC2 instance %s due to %s' % (EC2_INSTANCE_ID, str(e)))
        raise e






   
