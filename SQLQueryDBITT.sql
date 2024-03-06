declare CUR_UPDATE_DIEM CURSOR FOR
		SELECT MASV, MADT FROM SINHVIEN_DETAI
OPEN CUR_UPDATE_DIEM
DECLARE @MaSV CHAR(6), @MaDT CHAR(6)

FETCH NEXT FROM CUR_UPDATE_DIEM INTO @MaSV,@MaDT

WHILE(@@FETCH_STATUS=0)
BEGIN
	deCLARE @Diem1 float, @Diem2 float,@Diem3 float,@DiemTB float, @Xeploai NVArchar(15)

	--lay diem huong dan
	select @Diem1 = DIEM
	from GV_HDDT
	Where MASV = @MaSV AND MADT =@MaDT

	--lay diem tu phan bien
	select @Diem2 = DIEM
	from GV_PBDT
	Where MASV = @MaSV AND MADT =@MaDT

	--laydiem tu 3 giao vien hoi dong
	select @Diem3 = SUM(DIEM)
	from GV_HOIDONG
	Where MASV = @MaSV AND MADT =@MaDT
	-- TRUNG BÌNH DIỂM
		SET @DiemTB = (@Diem1 + @Diem2 + @Diem3)/5

	    -- XẾP LOẠI
		IF @DiemTB <5
			SET @XepLoai = N'Không đạt'
		ELSE IF @DiemTB >= 5 AND @DiemTB < 7
			SET @XepLoai = N'Trung Binh'
		ELSE IF  @DiemTB >= 7 AND @DiemTB < 8
			SET @XepLoai = N'Khá'
		ELSE 
			SET @XepLoai = N'Giỏi'

        -- UPDATE ĐIỂM VÀ XẾP LOẠI
        UPDATE  [dbo].[SINHVIEN_DETAI]
		   SET DIEM_TB =@DiemTB,
		   LOAI= @XepLoai
		WHERE MASV= @MaSV AND MADT=@MaDT
	FETCH NEXT FROM CUR_UPDATE_DIEM INTO @mASV,@MaDT
END

CLOSE CUR_UPDATE_DIEM
dEALLOCATE CUR_UPDATE_DIEM

select *from SINHVIEN_DETAI
update SINHVIEN_DETAI
set DIEM_TB = 0,
LOAI = ' '