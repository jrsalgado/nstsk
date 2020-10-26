var AWS = require("aws-sdk");
console.log("Region: ", AWS.config.region);
console.log('test')

const ecr = new AWS.ECR({ profile: 'nstask', region: 'us-east-1' })
var params = {
    repositoryName: 'tocleanup'
};
ecr.describeImages(params, function (err, data) {
    let usedLatest = ''
    if (err) console.log(err, err.stack);
    else {
        console.log('tags', data.imageDetails.length)
        let sorted = data.imageDetails.sort((a, b) => {
            return a.imagePushedAt - b.imagePushedAt;
        });
        sorted.forEach((e) => {
            console.log(`${e.imageDigest} ${e.imagePushedAt}`);
            if (e.imageTags.includes('latest')) {
                usedLatest = e
            }
        });
        let realLatestImage = sorted[sorted.length - 1]


        console.log('usedLatest: ', usedLatest)
        console.log('realLatestImage: ', realLatestImage)

        let toDelete = sorted.filter((e) => {
            if ((e.imageDigest === usedLatest.imageDigest) || (e.imageDigest == realLatestImage.imageDigest )) return
            else return e
        });

        toDelete.forEach((e) => {
            console.log(`${e.imageDigest} ${e.imageTags} ${e.imagePushedAt}`);
        });
    };
});