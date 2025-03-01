const AWS = require("aws-sdk");
require("dotenv").config();

const s3 = new AWS.S3({
    accessKeyId: process.env.AWS_ACCESS_KEY,
    secretAccessKey: process.env.AWS_SECRET_ACCESS_KEY,
    region: process.env.AWS_REGION
});

exports.uploadFile = async (fileBuffer, fileName, mimeType) => {
    const params = {
        Bucket: process.env.AWS_BUCKET_NAME,
        Key: fileName,
        Body: fileBuffer,
        ContentType: mimeType,
        ACL: "public-read"
    };
    const { Location } = await s3.upload(params).promise();
    return Location;
};
