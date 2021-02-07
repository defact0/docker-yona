작업개요
----

개인 업무PC에 `git저장소`으로 활용하기 위하여 만들게 되었다.  
(겸사겸사 docker 공부도 하고있는 중이다.)

작업환경은 Windows에서 `docker desktop for windows`을 사용한다.  
주의할 점은 Hyper-v 기능이 활성화 되어 VirtualBox 또는 VMware를 사용할 수 없다.



Yona?
---

- Git 저장소 기능이 내장된 설치형 이슈트래커
- Naver, Naver Labs 를 비롯하여 게임회사, 통신회사 고객센터, 공공기관, 투자사, 학교, 기업등에서 수년 간 실제로 사용되어 왔고 개선되어 온(Real world battled) 애플리케이션입니다
  - DEMO: [http://repo.yona.io](http://repo.yona.io)
  - Official Site: [http://yona.io](http://yona.io)



설치되는 SW
---

- mariadb 10.3
- zulu-8-8.46.0.19 (open-jdk)
- yona-1.14.0



사용방법
----

1. 파일을 다운로드 받는다.

   - `c:\docker-yona`에 압축을 해제한다.

2. docker image를 build한다.

   ```shell
   docker build -t youna:dev c:\docker-yona
   ```

3. docker container를 만든다.

   ```shell
   docker run --privileged --restart=always -p 3306:3306 -p 9000:9000 -dit --name yona youna:dev /sbin/init
   ```

   - 포트 설정
     - 3306=mariadb
     - 9000=yona

4. 요나(Yona) 기본 관리자 비밀번호 설정

   - http://127.0.0.1:9000/ 으로 접속

5. 요나(Yona) 시스템 재실행

   ```shell
   docker exec -it yona /bin/bash
   systemctl stop yona
   systemctl start yona
   ```


