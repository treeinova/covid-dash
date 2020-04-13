import 'moment/locale/pt-br'
import moment from 'moment'

moment.locale('pt-br');

export { default as listEquipments } from './listEquipments';
export { default as listCovid } from './listCovid';
export { default as getPopulationEstimates } from './getPopulationEstimates';
export { default as getHealthPlans } from './getHealthPlans';
export { default as listBeds } from './listBeds';
export { default as getAll } from './getAll';
