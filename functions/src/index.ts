import { Tabletojson } from 'tabletojson';
import axios from 'axios';
import * as moment from 'moment';
import * as functions from 'firebase-functions'



const complementaryIds = [
    51,
    52,
    65,
    66,
    74,
    75,
    76,
    77,
    78,
    79,
    80,
    81,
    82,
    83,
    85,
    86,
    92,
    93,
    94,
    95,
];

function parseBed(bed: any) {
    return {
        type: bed.Descrição,
        total: Number(bed.Existente.replace(/\./g, '')),
        sus: Number(bed.Sus.replace(/\./g, ''))
    }
}

function CombineHeaderAndTotals(acc: any, row: any, index: any, array: any) {
    const nextRow = array[index + 1];

    // Ignores total values (intercalates) and unmatched headers
    if (row.Codigo === 'TOTAL' || !nextRow) return acc;

    // Combines header with next (TOTAL) values
    // Should be 'Existente' and 'Sus' respectively but it came out wrong, so i had to compensate for it
    const combined = {
        type: row.Codigo,
        total: Number(nextRow.Descrição.replace(/\./g, '')),
        sus: Number(nextRow.Existente.replace(/\./g, '')),
    };

    return [...acc, combined];
};

function FilterHeaderAndTotals(table: any, index: any, array: any) {
    index === 0 || // Gets the first header
        table.Codigo === 'TOTAL' || // Gets all 'TOTAL' numbers
        array[index - 1]?.Codigo === 'TOTAL'; // Gets all headers before 'TOTAL'
}


const defaultError =
    'Beds not found. DataSUS might be offline or changed key names';

async function listBeds(state = 35, city = 354340) {
    const { data } = await axios.get('Mod_Ind_Tipo_Leito.asp', {
        baseURL: 'http://cnes2.datasus.gov.br/',

        // responseEncoding: 'latin1',
        params: { VEstado: state, VMun: city },
    });

    const tables = Tabletojson.convert(data, { useFirstRowForHeadings: true })
        .pop()
        .slice(1);

    const totals = tables
        .filter(FilterHeaderAndTotals)
        .reduce(CombineHeaderAndTotals, []);

    const complementary = tables
        .filter((table: any) => complementaryIds.includes(Number(table.Codigo)))
        .map(parseBed);

    if (!tables[0] && data.includes('Site fora do ar'))
        throw new Error(defaultError);

    const updatedAt = moment(
        data.match(/<option value=\d*>(\d*\/\d*)/)[1],
        'MM/YYYY'
    ).toDate();

    return { data: { totals, complementary }, updatedAt };
}


// exports.priceTrackerCron = functions.runWith({ memory: '2GB', timeoutSeconds: 300, }).pubsub.schedule('every 1 minutes').onRun((context) => {

// });

export const getAllBeds = functions.https.onRequest((request, response) => {
    return listBeds().then(res => {
        console.log(res);
        response.send(res);
    })

});
