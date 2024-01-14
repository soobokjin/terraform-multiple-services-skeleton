## Install (TBU)

caution

- terraform version 1.3.7 이상 권장
  https://github.com/hashicorp/terraform/issues/31846

## Deploy Flow

- main 에서 feature 브랜치 생성
- Provision 할 application 정보 추가 (아래 How To 참조)
- PR
- Main merge 후 local 에서 `terraform apply` 수행하여 provision 완료 (이 부분은 Github action 등에서 수행하는 것이 베스트이나 시간 관계상 매뉴얼로 대체)

## How To (BE)

### prototype application 추가하기

- prototypes/applications directory 로 이동

```jsx

❯ cd live/prod/prototypes/applications
```

- `local-config.yaml` 에 BE 정보 추가

```jsx
prototypes:
  - service_name: test
    instance_type: t3a.medium
    url_prefix: test1
    port: 3000
    listener_priority: 1
```

- 추가 후 PR 요청

### Provision 진행하기

- prototypes/applications directory 로 이동

```jsx
❯ cd live/prod/prototypes/applications
```

- `terraform init` 실행

```jsx

❯ terraform init
```

- terraform plan & apply 실행

```jsx
terraform plan
terraform apply
```

- output 에 출력되는 public ip 로 접근하여 서버 세팅

## How To (FE)

### prototype fe application 추가하기

- prototypes/applications-fe directory 로 이동

```jsx

❯ cd live/prod/prototypes/applications-fe
```

- `local-config.yaml` 에 BE 정보 추가

```jsx
prototypes:
  - service_name: reward-fe
    instance_type: t3a.medium
    url_prefix: onboard  //sub domain name. onboard.noox.world
    port: 5000  // FE server port
```

- 추가 후 PR 요청

### Provision 진행하기

- prototypes/applications-fe directory 로 이동

```jsx
❯ cd live/prod/prototypes/applications-fe
```

- `terraform init` 실행

```jsx

❯ terraform init
```

- terraform plan & apply 실행

```jsx
terraform plan
terraform apply
```

- output 에 출력되는 public ip 로 접근하여 서버 세팅
