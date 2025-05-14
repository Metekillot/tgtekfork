import { Input, Section, Stack } from 'tgui-core/components';
import { BooleanLike } from 'tgui-core/react';

import { useBackend } from '../backend';
import { Window } from '../layouts';

type Data = {
  current_name: string;
  current_assignment: string;
  current_trim: string;
  current_age: number;
  currently_wallet_spoofing: BooleanLike;
};

const NameSection = (current_name: string) => {
  return (
    <Section title="Name">
      <Input>{current_name}</Input>
    </Section>
  );
};

export const ChameleonCardForge = (props) => {
  const { act, data } = useBackend<Data>();
  const {
    current_name,
    current_assignment,
    current_trim,
    current_age,
    currently_wallet_spoofing,
  } = data;

  return (
    <Window width={500} height={300} theme="syndicate">
      <Window.Content fitted>
        <Stack inlineFlex justify="space-between" />
        <Stack inlineFlex justify="space-between" />
      </Window.Content>
    </Window>
  );
};
