import {} from 'aws-sdk';

interface IEvent{
}

exports.handler = async (event: IEvent) => {
    return {
        'status': 200
    };
};
