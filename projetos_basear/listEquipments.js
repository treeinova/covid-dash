import { Tabletojson } from 'tabletojson';
import { pick } from 'lodash';
import axios from 'axios';
import moment from 'moment';
import Cache from '../lib/Cache';

const keys = {
  id: 'Código',
  name: 'Equipamento',
  total: 'Existentes',
  using: 'Em Uso',
  susTotal: 'ExistentesSUS',
  susUsing: 'Em Uso SUS',
};

const defaultError =
  'Equipments not found. DataSUS might be offline or changed key names';

const keyValues = Object.values(keys).join();

const correctResults = equipment => Object.keys(equipment).join() === keyValues;

const sortById = (a, b) => a.id - b.id;

const mapResults = table => {
  const id = Number(table[keys.id].replace(/\./g, ''));
  const total = Number(table[keys.total].replace(/\./g, ''));
  const using = Number(table[keys.using].replace(/\./g, ''));
  const susTotal = Number(table[keys.susTotal].replace(/\./g, ''));
  const susUsing = Number(table[keys.susUsing].replace(/\./g, ''));

  return {
    id,
    name: table[keys.name],
    total,
    remaining: total - using,
    sus: {
      total: susTotal,
      remaining: susTotal - susUsing,
    },
  };
};

async function listEquipments(state, city) {
  const { data } = await axios.get('Mod_Ind_Equipamento.asp', {
    baseURL: 'http://cnes2.datasus.gov.br/',
    responseEncoding: 'latin1',
    params: { VEstado: state, VMun: city },
  });

  const equipments = Tabletojson.convert(data, { useFirstRowForHeadings: true })
    .pop()
    .slice(1)
    .filter(correctResults);

  if (!equipments[0] && data.includes('Site fora do ar'))
    throw new Error(defaultError);

  const options = data.match(/<option value=\d*>(\d*\/\d*)/);
  const updatedAt =
    state === '00' ? new Date() : moment(options[1], 'MM/YYYY').toDate();

  return { data: equipments.map(mapResults).sort(sortById), updatedAt };
}

// Cache the result for one day before doing another DATASUS request
const listEquipmentsMemo = Cache.cacheFunction(listEquipments, {
  maxAge: 60 * 60 * 24,
  key: 'AllEquipments',
});

async function CompareCountryCity(state, city) {
  const [countryResults, cityResults] = await Promise.all([
    listEquipmentsMemo('00'),
    listEquipmentsMemo(state, city),
  ]);

  const data = countryResults.data.map(equipment => {
    const cityMatch = cityResults.data.find(e => e.id === equipment.id);
    return {
      id: equipment.id,
      name: equipment.name,
      country: pick(equipment, ['total', 'remaining', 'sus']),
      city: {
        total: (cityMatch && cityMatch.total) || 0,
        remaining: (cityMatch && cityMatch.remaining) || 0,
        sus: (cityMatch && cityMatch.sus) || { total: 0, remaining: 0 },
      },
    };
  });

  return { data, updatedAt: cityResults.updatedAt };
}

export default CompareCountryCity;
