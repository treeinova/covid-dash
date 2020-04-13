import { Tabletojson } from 'tabletojson';
import qs from 'qs';
import moment from 'moment';
import axios from 'axios';
import Cache from '../lib/Cache';
import ansCityCodes from '../resources/ansCityCodes';

const defaults = {
  Linha: 'Competência',
  Coluna: '--Não-Ativa--',
  Incremento: 'Assistência_Médica',
  Arquivos: 'tb_bb_1912.dbf',
  SSexo: 'TODAS_AS_CATEGORIAS__',
  SFaixa_etária: 'TODAS_AS_CATEGORIAS__',
  STipo_de_contratação: 'TODAS_AS_CATEGORIAS__',
  SÉpoca_de_Contratação: 'TODAS_AS_CATEGORIAS__',
  SSegmentação: 'TODAS_AS_CATEGORIAS__',
  SSegmentação_grupo: 'TODAS_AS_CATEGORIAS__',
  SUF: 'TODAS_AS_CATEGORIAS__',
  SGrande_Região: 'TODAS_AS_CATEGORIAS__',
  SCapital: 'TODAS_AS_CATEGORIAS__',
  SMicrorregião: 'TODAS_AS_CATEGORIAS__',
  SMunicípio: 'TODAS_AS_CATEGORIAS__',
  formato: 'table',
  mostre: 'Mostra',
  'SFaixa_etária-Reajuste': 'TODAS_AS_CATEGORIAS__',
  'SReg._Metropolitana': 'TODAS_AS_CATEGORIAS__',
};

const ANS = axios.create({
  baseURL: 'http://www.ans.gov.br/anstabnet/cgi-bin',
  headers: { 'content-type': 'application/x-www-form-urlencoded' },
});

async function getLatestFile() {
  const { data } = await ANS.get('/dh?dados/tabnet_02.def');
  const match = data.match(/(tb_bb_(\d*)\.dbf)" SELECTED >(.*)/);

  return {
    data: match[1],
    updatedAt: moment(match[3], 'MMM/YYYY').toDate(),
  };
}

// // Cache the result for one month before doing another request
const getLastFileMemo = Cache.cacheFunction(getLatestFile, {
  key: 'LatestFile',
  maxAge: 60 * 60 * 24 * 30,
});

async function listHealthPlans(city) {
  const cityCode = ansCityCodes[city];
  if (!cityCode) return 0;

  const lastFile = await getLastFileMemo();

  const params = {
    ...defaults,
    SMunicípio: cityCode,
    Arquivos: lastFile.data,
  };

  const { data } = await ANS.post(
    '/tabnet?dados/tabnet_02.def',
    qs.stringify(params, { charset: 'iso-8859-1' })
  );

  const equipments = Tabletojson.convert(data, {
    useFirstRowForHeadings: true,
  });

  const healthPlans = equipments[0][1]['Assistência Médica'].replace(/\./g, '');
  return { value: Number(healthPlans), updatedAt: lastFile.updatedAt };
}

// Cache the result for one month before doing another request
export default Cache.cacheFunction(listHealthPlans, {
  key: 'HealthPlans',
  maxAge: 60 * 60 * 24 * 30,
});
