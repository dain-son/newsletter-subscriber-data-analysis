# 구독자 통계 파일 경로 
path = " "
# 구독자 통계 파일 이름
file_name = " "

save_name = file_name.split('_')[2].split('.')[0]

# del_number: 삭제할 구독자 수
# min_rate: 이하이면 우선적으로 삭제
# max_rate: min_rate이하 구독자가 del_number보다 적을 때, 이 오픈율까지는 삭제해도 된다..!

def find_target(df, min_rate, max_rate, del_number):
    
    # dataframe 불러오기
    df = pd.read_csv(f'{path}{file_name}')
    
    # '구독 중'인 구독자 추출
    df = df[df['이메일 수신 상태']=="구독 중"]
    # '주소록 최신화 대상'아닌 구독자 추출
    df = df[~df['그룹'].str.contains('주소록 최신화 대상', na=False)]

    # min_rate이하 오픈율 보인 구독자가 삭제하려는 구독자 수보다 많으면?
    if len(df[df['오픈율']<= min_rate])>=del_number:
        
        # min_rate보다 적은 오픈율 구독자 추출
        df = df[df['오픈율']<= min_rate]
        
        # 구독일 오래된 사람부터
        df = df.sort_values(by="구독일", ascending=True)
        
        # 삭제
        df_del = df.reset_index(drop=True).loc[:del_number-1,]
    
    # min_rate이하 오픈율 보인 구독자가 삭제하려는 구독자 수보다 적으면?
    else:
        
        # 일단 min_rate보다 오픈율 낮은 구독자 빼놓기
        df_del = df[df['오픈율']<= min_rate]
        
        # min_rate보다 높고 max_rate보다 적은 오픈율 구독자 추출
        df = df[(df['오픈율']>min_rate) & (df['오픈율']<= max_rate)]
        
        # 추가로 삭제해야하는 구독자 수
        length = del_number - len(df_del) 
        
        # 오픈율, 구독일 기준 정렬
        df = df.sort_values(by=["오픈율","구독일"], ascending=True)
        
        # 추가로 삭제해야하는 만큼 추출 (오픈율 같으면 구독일 오래된 순서로)
        df_del2 = df.reset_index(drop=True).loc[:length-1,]
        
        # 데이터프레임 합쳐서 삭제
        df_del = pd.concat([df_del,df_del2])
    
    
    # 같은 경로에 delete.csv로 저장
    df_del.to_csv(f'{path}{save_name}_delete.csv')

		# 데이터프레임 보여주기
    return(df_del)
