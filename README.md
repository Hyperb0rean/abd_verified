# ITMO_FP

Сосновцев Григорий Алексеевич P34102

### Lab 4 - Vector clock algorithm

С помощью фреймворка Verdi построена модель распределенной системы с векторными часами
Участники сообщения - ноды, которые могут оправить себе локальное событие или отправить другой ноде по сети сообщение. 

Каждое событие влечет инкремент счетчика векторных часов с id равным номеру ноды.
При получении сообщения нода сверяет свои векторные часы с часами полученными в сообщении
выбирая покомпонентый максимум.

```v

Definition vector_leq (v1 v2 : Vector) : Prop :=
  forall n, In n (map fst v1) -> In n (map fst v2) ->
  get_counter v1 n <= get_counter v2 n.

Definition vector_lt (v1 v2 : Vector) : Prop :=
  vector_leq v1 v2 /\ exists n, get_counter v1 n < get_counter v2 n.

```

Vector clocks relation defined as following.

Main result is isomorphism between happens-before relationship and vector clocks.
```v
Theorem casuality_theorem :
  forall s1 s2,
    ((vclock s1) <=< (vclock s2)) <->
    happens_before s1 s2.
```