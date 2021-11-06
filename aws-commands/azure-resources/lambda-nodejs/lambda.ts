import {} from 'aws-sdk';

interface IEvent{
}

export async function handler (event: IEvent) {
    return {
        statusCode: 202,
        body: 'Accepted.'
    };
};
