import { Fragment } from 'inferno';
import { act } from '../byond';
import { Section, Box, Button, Table } from '../components';
import { classes } from 'common/react';

export const Vending = props => {
  const { state } = props;
  const { config, data } = state;
  const { ref } = config;
  let inventory;
  let custom = false;
  const onstation = true;
  if (data.extended_inventory && (data.coin || data.bill)) {
    inventory = [
      ...data.product_records,
      ...data.hidden_records,
      ...data.coin_records,
    ];
  } else if (data.extended_inventory) {
    inventory = [
      ...data.product_records,
      ...data.hidden_records,
    ];
  } else if (data.coin || data.bill) {
    inventory = [
      ...data.product_records,
      ...data.coin_records,
    ];
  } else {
    inventory = [
      ...data.product_records,
    ];
  }
  return (
    <Fragment>
      {data.coin && (
        <Section title="Coins">
          <Button
            content={"Take out the coin"}
            onClick={() => act(ref, 'takeoutcoin')} />
        </Section>
      )}
      {data.bill && (
        <Section title="Bill">
          <Button
            content={"Take out the bill"}
            onClick={() => act(ref, 'takeoutbill')} />
        </Section>
      )}
      <Section title="Products" >
        <Table>
          {inventory.map((product => {
            return (
              <Table.Row key={product.name}>
                <Table.Cell>
                  {product.base64 ? (
                    <img
                      src={`data:image/jpeg;base64,${product.img}`}
                      style={{
                        'vertical-align': 'middle',
                        'horizontal-align': 'middle',
                      }} />
                  ) : (
                    <span
                      className={classes(['vending32x32', product.path])}
                      style={{
                        'vertical-align': 'middle',
                        'horizontal-align': 'middle',
                      }} />
                  )}
                  <b>{product.name}</b>
                </Table.Cell>
                <Table.Cell>
                  <Box color={custom
                    ? 'good'
                    : data.stock[product.name] <= 0
                      ? 'bad'
                      : data.stock[product.name] <= (product.max_amount / 2)
                        ? 'average'
                        : 'good'}>
                    {data.stock[product.name]} in stock
                  </Box>
                </Table.Cell>
                <Table.Cell>
                  {custom && (
                    <Button
                      content={'Vend'}
                      onClick={() => act(ref, 'dispense', {
                        'item': product.name,
                      })} />
                  ) || (
                    <Button
                      content={'Vend'}
                      onClick={() => act(ref, 'vend', {
                        'ref': product.ref,
                      })} />
                  )}
                </Table.Cell>
              </Table.Row>
            );
          }))}
        </Table>
      </Section>
    </Fragment>
  );
};
