import { Client } from 'basic-ftp';
import { fs } from 'memfs';
import { promisify } from 'util';
import xlsx from 'xlsx';
import Cache from '../lib/Cache';
import moment from 'moment'

const readFile = promisify(fs.readFile);
async function listPopulationEstimates() {
  const client = new Client();
  await client.access({ host: 'ftp.ibge.gov.br' });

  // Finds most recent estimate filename
  await client.cd('Estimativas_de_Populacao');
  const years = await client.list();
  const lastYear = years[years.length - 1];

  // Finds desired (TCU) sheet filename
  await client.cd(lastYear.name);
  const files = await client.list();
  const sheet = files.find(file => /estimativa_TCU.*\.xls/.test(file.name));
  const updatedAt = moment(sheet.rawModifiedAt, 'MMM DD hh:mm').toDate()

  // Downloads file to memory
  const temporaryFile = fs.createWriteStream('/tmp');
  await client.downloadTo(temporaryFile, sheet.name);
  const data = await readFile('/tmp');

  await client.close();

  // Reads the sheet
  const citiesSheet = xlsx.read(data).Sheets['Municípios'];

  // Ignores the first row (title - unwanted in this case)
  const range = xlsx.utils.decode_range(citiesSheet['!ref']);
  range.s.r = 1;
  citiesSheet['!ref'] = xlsx.utils.encode_range(range);

  // Maps properties to english
  const value = xlsx.utils.sheet_to_json(citiesSheet).map(estimate => ({
    state: estimate.UF,
    city: estimate['NOME DO MUNICÍPIO'],
    population: estimate[' POPULAÇÃO ESTIMADA '], // Weird spaces are intentional and necessary
  }));

  return { data: value, updatedAt };
}

// Cache the result for two months before updating
export default Cache.cacheFunction(listPopulationEstimates, {
  maxAge: 60 * 60 * 24 * 60,
  key: 'Population',
});
