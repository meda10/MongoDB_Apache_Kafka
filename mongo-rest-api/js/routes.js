const express = require('express');
const recordRoutes = express.Router();
const dbo = require('./connect');

recordRoutes.route('/hlasy').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const projection = { _id: 0, id_kraje: 1, preferencni: 1, strana: 1};

    await dbConnect
        .collection('hlasy')
        .find({})
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send('Error fetching listings!');
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/kraj/:id').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { ID_KRAJE: req.params.id };
    const projection = { _id: 0, ID_KRAJE: 1, COUNT: 1, STRANA: 1};

    await dbConnect
        .collection('hlasy_sum_kraj')
        .find(query)
        .project(projection)
        .sort( { COUNT : - 1 } )
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE}!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/krajnejlepsi/:id').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { ID_KRAJE: req.params.id };
    const projection = { _id: 0, ID_KRAJE: 1, COUNT: 1, STRANA: 1 };
    const sort = { COUNT : -1 };

    await dbConnect
        .collection('hlasy_sum_kraj')
        .find(query)
        .project(projection)
        .sort(sort)
        .limit(1)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE}!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/krajeNejlepsi').get(async function (req, res) {
    const dbConnect = dbo.getDb();

    await dbConnect
        .collection('hlasy_sum_kraj')
        .aggregate([
            {$project : { _id: 0, ID_KRAJE : 1, COUNT: 1, STRANA: 1 }},
            {$sort : { ID_KRAJE : 1, COUNT : -1 }},
            {$group : {
                _id : "$ID_KRAJE",
                total: {$first : "$COUNT"},
                strana: {$first : "$STRANA"}
            }}
        ])
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not found` + err);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/krajHlasuCelkem/:id').get(async function (req, res) {
    const dbConnect = dbo.getDb();

    await dbConnect
        .collection('hlasy_sum_kraj')
        .aggregate([
            {$group : {
                _id : "$ID_KRAJE",
                total: {$sum : "$COUNT"}
            }},
            { $match: { "_id": req.params.id } }
        ])
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find `);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/hlasuCelkem').get(async function (req, res) {
    const dbConnect = dbo.getDb();

    await dbConnect
        .collection('hlasy_sum_kraj')
        .aggregate([
            {$group : {
                _id: "",
                total: {$sum : "$COUNT"}
            }},
        ])
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find hlasu celkem!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/hlasuMaxCelkemKraj/:id').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    await dbConnect
        .collection('kraje')
        .find({ _id: req.params.id })
        .project ({ _id: 1, maxPocetHlasu: 1, pocetVolicu : 1 })
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find hlasu celkem!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/hlasuMaxCelkem').get(async function (req, res) {
    const dbConnect = dbo.getDb();

    await dbConnect
        .collection('kraje')
        .aggregate([
            {$group : {
                _id: "",
                total: {$sum : "$maxPocetHlasu"},
                totalPeople: {$sum : "$pocetVolicu"}
            }},
        ])
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find hlasu celkem!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/kraje').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const projection = { _id: 1, nazev: 1 };

    await dbConnect
        .collection('kraje')
        .find({})
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE}!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/kraj/:id/strana/:name').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { ID_KRAJE: req.params.id, STRANA: req.params.name };
    const projection = { _id: 0, ID_KRAJE: 1, COUNT: 1, STRANA: 1};

    await dbConnect
        .collection('hlasy_sum_kraj')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE} or strana with name ${query.STRANA}!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/kraj/:id/preferencni').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { ID_KRAJE: req.params.id };
    const projection = { _id: 0, ID_KRAJE: 1, COUNT: 1, STRANA: 1, PREFERENCNI: 1 };

    await dbConnect
        .collection('preferencni_hlasy_sum_kraj')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE}!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/kraj/:id/preferencni/:id_pref').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { ID_KRAJE: req.params.id, PREFERENCNI: req.params.id_pref };
    const projection = { _id: 0, ID_KRAJE: 1, COUNT: 1, STRANA: 1, PREFERENCNI: 1 };

    await dbConnect
        .collection('preferencni_hlasy_sum_kraj')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find kraj with id ${query.ID_KRAJE} or person with id ${query.PREFERENCNI}!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/cr').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = {};
    const projection = { _id: 1, COUNT: 1 };

    await dbConnect
        .collection('hlasy_sum_cr')
        .find(query)
        .project(projection)
        .sort({ COUNT: -1 })
        .toArray(function (err, result) {
            if (err) {
                res.status(400);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/cr/strana/:name').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { _id: req.params.name };
    const projection = { _id: 1, COUNT: 1 };

    await dbConnect
        .collection('hlasy_sum_cr')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find strana with name ${query._id}!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/cr/preferencni').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { };
    const projection = { _id: 1, COUNT: 1 };

    await dbConnect
        .collection('preferencni_hlasy_sum_cr')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/cr/preferencni/:id_pref').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = { _id: req.params.id_pref };
    const projection = { _id: 1, COUNT: 1 };

    await dbConnect
        .collection('preferencni_hlasy_sum_cr')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error can not find person with id ${query._id}!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/lidi').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = {};
    const projection = { _id: 0, id: 1, name: 1, strana: 1 };

    await dbConnect
        .collection('lidi')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error!`);
            } else {
                res.json(result);
            }
        });
});

recordRoutes.route('/strany').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    const query = {};
    const projection = { _id: 0, color: 1, strana: 1 };

    await dbConnect
        .collection('strany')
        .find(query)
        .project(projection)
        .toArray(function (err, result) {
            if (err) {
                res.status(400).send(`Error!`);
            } else {
                res.json(result);
            }
        });
});


recordRoutes.route('/pocetVolicu/:nb/kraj/:id').get(async function (req, res) {
    const dbConnect = dbo.getDb();
    await dbConnect
        .collection('kraje')
        .update({'_id' : req.params.id},
                {$set:{'pocetVolicu' : Number(req.params.nb) }}, {multi:true});

    res.status(200).send('updated');
});



// // This section will help you get a list of all the records.
// recordRoutes.route('/listings').get(async function (_req, res) {
//     const dbConnect = dbo.getDb();
//
//     dbConnect
//         .collection('listingsAndReviews')
//         .find({})
//         .limit(50)
//         .toArray(function (err, result) {
//             if (err) {
//                 res.status(400).send('Error fetching listings!');
//             } else {
//                 res.json(result);
//             }
//         });
// });
//
// // This section will help you create a new record.
// recordRoutes.route('/listings/recordSwipe').post(function (req, res) {
//     const dbConnect = dbo.getDb();
//     const matchDocument = {
//         listing_id: req.body.id,
//         last_modified: new Date(),
//         session_id: req.body.session_id,
//         direction: req.body.direction,
//     };
//
//     dbConnect
//         .collection('matches')
//         .insertOne(matchDocument, function (err, result) {
//             if (err) {
//                 res.status(400).send('Error inserting matches!');
//             } else {
//                 console.log(`Added a new match with id ${result.insertedId}`);
//                 res.status(204).send();
//             }
//         });
// });
//
// // This section will help you update a record by id.
// recordRoutes.route('/listings/updateLike').post(function (req, res) {
//     const dbConnect = dbo.getDb();
//     const listingQuery = { _id: req.body.id };
//     const updates = {
//         $inc: {
//             likes: 1,
//         },
//     };
//
//     dbConnect
//         .collection('listingsAndReviews')
//         .updateOne(listingQuery, updates, function (err, _result) {
//             if (err) {
//                 res
//                     .status(400)
//                     .send(`Error updating likes on listing with id ${listingQuery.id}!`);
//             } else {
//                 console.log('1 document updated');
//             }
//         });
// });
//
// // This section will help you delete a record.
// recordRoutes.route('/listings/delete/:id').delete((req, res) => {
//     const dbConnect = dbo.getDb();
//     const listingQuery = { listing_id: req.body.id };
//
//     dbConnect
//         .collection('listingsAndReviews')
//         .deleteOne(listingQuery, function (err, _result) {
//             if (err) {
//                 res
//                     .status(400)
//                     .send(`Error deleting listing with id ${listingQuery.listing_id}!`);
//             } else {
//                 console.log('1 document deleted');
//             }
//         });
// });

module.exports = recordRoutes;
