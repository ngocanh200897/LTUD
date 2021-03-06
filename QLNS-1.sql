-- Tạo csdl
create Database Proj_QuanLyNhaSach
-- Su dung csdl
go
use Proj_QUANLYNHASACH

-- Tạo các Table
--Table ADMIN(đăng nhập)
go
create table ADMIN(
	UserName nchar(25) primary key not null,
	PassWords nchar(25) not null,
	Quyen nvarchar not null --(Quyền truy cập)
)
-- Tạo table nhà sản xuất
go
create table NSX(
	MaNSX nchar(10) primary key not null,
	TenNSX nvarchar(100) not null,
	DiaChi nvarchar(250) not null,
	SDT char(11)
)
-- Tạo table kho
go
create table KHO(
	MaKho nchar(10) primary key not null,
	TenKho nvarchar(200) not null,
	NgayNhapKho nvarchar(30) not null,
	SoLuongNhap int not null,
	NgayXuat nvarchar(30) not null,
	SoLuongXuat int not null,
	SoLuongTon int not null,
	SoPhieu nchar(10) not null
)
-- Tạo table sản phẩm
go
create table SANPHAM(
	MaSP nchar(10) primary key not null,
	TenSP nvarchar(50) not null,
	SoLuong int not null,
	GiaTien int not null,
	MaNSX nchar(10) not null,
	MaLoaiSP nchar(10) not null,
	MaLoaiSach nchar(10) ,
	MaTG nchar(10) ,
	MaKho nchar(10) not null,
)
-- Tạo table chi tiet hóa đơn
go
create table CHITIETHOADON(
	MaHD nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuong int not null
)
-- Tạo table loại san pham
go
create table LOAISANPHAM(
	MaLoaiSP nchar(10) primary key not null,
	TenLoaiSP nvarchar (100) not null
)
-- Tạo table loại sach
go
create table LOAISACH(
	MaLoaiSach nchar(10) primary key not null,
	TenLoaiSach nvarchar (100) not null
)
-- Tạo table tac gia
go
create table TACGIA(
	MaTG nchar(10) primary key not null,
	TenTG nvarchar (100) not null,
	NamSinh	int
)
-- Tạo table khách hàng
go
create table KHACHHANG(
	MaKH nchar(10) primary key not null,
	TenKH nvarchar(25) not null,
	DiaChi nvarchar(250) not null,
	SDT char(11)
)
-- Tạo table nhân viên
go
create table NHANVIEN(
	MaNV nchar(10) primary key not null,
	TenNV nvarchar(25) not null,
	DiaChi nvarchar(250) not null,
	GioiTinh nvarchar(5),
	SDT char(11),
	TienLuong int,
)
-- Tạo table hóa đơn
go
create table HOADON(
	MaHD nchar(10) primary key not null,
	MaNV nchar(10) not null,
	MaKH nchar(10) not null,
	MaSP nchar(10) not null,
	SoLuong int not null,
	NgayLapHD nvarchar(20) not null,
)

-- them cac rang buoc
--rang buoc khoa chinh
go
alter table CHITIETHOADON
add constraint pk_chitiethoadon primary key( MaHD, MaSP)

--thêm khóa ngoại bảng tác giả - sản phẩm
go
alter table SANPHAM 
Add constraint fk_TACGIA_SANPHAM foreign key  (MaTG)  references TACGIA(MaTG)

--thêm khóa ngoại bảng nhân viên - hóa đơn
go
alter table HOADON
Add constraint fk_NHANVIEN_HOADON foreign key  (MaNV)  references NHANVIEN(MaNV)

--thêm khóa ngoại bảng khách hàng - hóa đơn
go
alter table HOADON
Add constraint fk_KHACHHANG_HOADON foreign key  (MaKH)  references KHACHHANG(MaKH)

--thêm khóa ngoại bảng Nhà sản xuất - san pham
go
alter table SANPHAM 
Add constraint fk_NSX_SANPHAM foreign key  (MaNSX)  references NSX(MaNSX)

--thêm khóa ngoại bảng loai sp - san pham
go
alter table SANPHAM 
Add constraint fk_LOAISANPHAM_SANPHAM foreign key  (MaLoaiSP)  references LOAISANPHAM(MaLoaiSP)

--thêm khóa ngoại bảng loai sach - san pham
go
alter table SANPHAM 
Add constraint fk_LOAISACH_SANPHAM foreign key  (MaLoaiSach)  references LOAISACH(MaLoaiSach)

--thêm khóa ngoại bảng Kho - sản phẩm
go
alter table SANPHAM
Add constraint fk_KHO_SANPHAM foreign key  (MaKho)  references KHO(MaKho)
-- khoa ngoai san pham - chi tiet sp
go
alter table ChiTietHoaDon 
Add constraint fk_SanPham_ChiTietHoaDon foreign key  (MaSP)  references SanPham(MaSP) 

-- khoa ngoai hoa don - chi tiet sp
go
alter table ChiTietHoaDon
Add constraint fk_HoaDon_ChiTietHoaDon foreign key  (MaHD)  references HoaDon(MaHD)

--them xoa sua tac gia
--proc them tac gia
go
create proc sp_themTacGia(@MaTG nchar(10),@TenTG nvarchar(100),@NamSinh int)
as
insert into TACGIA values(@MaTG,@TenTG,@NamSinh)

-- THỰC THI 

--proc sua tac gia
go
create proc sp_capnhapTacGia(@MaTG nchar(10),@TenTG nvarchar(100),@NamSinh int)
as
update TACGIA
set TenTG = @TenTG,
NamSinh = @NamSinh
where MaTG = @MaTG
--proc xoa tac gia
go
create proc sp_xoaTacGia(@ma nchar(10))
as
delete from TACGIA where MaTG = @ma

--them xoa sua san pham
--proc them san pham
go
create proc sp_themSanPham(@MaSP nchar(10),@TenSP nvarchar(50),@SoLuong int,@GiaTien int,@MaNSX nchar(10),@MaLoaiSP nchar(10),@MaLoaiSach nchar(10),@MaTG nchar(10),@MaKho nchar(10))
as
insert into SANPHAM values(@MaSP,@TenSP,@SoLuong,@GiaTien,@MaNSX,@MaLoaiSP,@MaLoaiSach,@MaTG,@MaKho)

-- thực thi 

--proc sua san pham
go
create proc sp_capnhapSanPham(@MaSP nchar(10),@TenSP nvarchar(50),@SoLuong int,@GiaTien int,@MaNSX nchar(10),@MaLoaiSP nchar(10),@MaLoaiSach nchar(10),@MaTG nchar(10),@MaKho nchar(10))
as
update SANPHAM
set TenSP = @TenSP,
SoLuong = @SoLuong,
GiaTien = @GiaTien,
MaNSX = @MaNSX,
MaLoaiSP = @MaLoaiSP,
MaLoaiSach = @MaLoaiSach,
MaTG = @MaTG,
MaKho = @MaKho
where MaSP = @MaSP
--proc xoa san pham
go
create proc sp_xoaSanPham(@ma nchar(10))
as
delete from SANPHAM where MaSP = @ma

--them xoa sua nsx
-- proc them nsx
go
create proc sp_themNSX(@MaNSX nchar(10),@TenNSX nvarchar(100),@DiaChi nvarchar(250),@SDT char(11))
as
insert into NSX values(@MaNSX,@TenNSX,@DiaChi,@SDT)


--proc sua nsx
go
create proc sp_capnhapNSX(@MaNSX nchar(10),@TenNSX nvarchar(100),@DiaChi nvarchar(250),@SDT char(11))
as
update NSX
set TenNSX = @TenNSX,
DiaChi = @DiaChi,
SDT = @SDT
where MaNSX = @MaNSX
-- xoa nsx
go
create proc sp_xoaNSX(@ma nchar(10))
as
delete from NSX where MaNSX = @ma

--them xoa sua nhan vien
--them
go
create proc sp_themNV(@MaNV nchar(10),@TenNV nvarchar(25),@DiaChi nvarchar(250),@GioiTinh nvarchar(5),@SDT char(11),@TienLuong int)
as
insert into NHANVIEN values(@MaNV,@TenNV,@DiaChi,@GioiTinh,@SDT,@TienLuong)
go
create proc sp_capnhapNV(@MaNV nchar(10),@TenNV nvarchar(25),@DiaChi nvarchar(250),@GioiTinh nvarchar(5),@SDT char(11),@TienLuong int)
as
update NHANVIEN
set TenNV = @TenNV,
DiaChi = @DiaChi,
GioiTinh = @GioiTinh,
SDT =@SDT,
TienLuong = @TienLuong
where MaNV = @MaNV
--xoa nhan vien
go
create proc sp_xoaNV(@ma nchar(10))
as
delete from NHANVIEN where MaNV = @ma

--them xoa sua loai sp
--them
go
create proc sp_themLoaiSP(@MaLoaiSP nchar(10),@TenLoaiSP nvarchar (100))
as
insert into LOAISANPHAM values(@MaLoaiSP,@TenLoaiSP)
--xoa
go
create proc sp_xoaLSP(@ma nchar(10))
as
delete from LOAISANPHAM where MaLoaiSP = @ma
--sua
go
create proc sp_capnhapLSP(@MaLoaiSP nchar(10),@TenLoaiSP nvarchar (100))
as
update LOAISANPHAM
set TenLoaiSP = @TenLoaiSP
where MaLoaiSP = @MaLoaiSP

--them xoa sua loai sach
--proc them
go
create proc sp_themLS(@MaLoaiSach nchar(10),@TenLoaiSach nvarchar (100))
as
insert into LOAISACH values(@MaLoaiSach,@TenLoaiSach)

-- thực thi 

-- proc sua
go
create proc sp_capnhapLS(@MaLoaiSach nchar(10),@TenLoaiSach nvarchar (100))
as
update LOAISACH
set TenLoaiSach = @TenLoaiSach
where MaLoaiSach = @MaLoaiSach
--xoa loai sach
go
create proc sp_xoaLS(@ma nchar(10))
as
delete from LOAISACH where MaLoaiSach = @ma

---thêm xóa sữa kho 
-- proc them kho
go
create proc sp_themKho(@MaKho nchar(10),@TenKho nvarchar(200),@NgayNhapKho nvarchar(30),@SoLuongNhap int, @NgayXuat nvarchar(30),@SoLuongXuat int, @SoLuongTon int, @SoPhieu nchar(10) )
as
insert into KHO values(@MaKho,@TenKho,CONVERT(varchar,@NgayNhapKho, 103) ,@SoLuongNhap, CONVERT(varchar,@NgayXuat, 103),@SoLuongXuat, @SoLuongTon, @SoPhieu)

-- thực thi 

--proc sua kho
go
create proc sp_capnhapKho(@MaKho nchar(10),@TenKho nvarchar(200),@NgayNhapKho nvarchar(30),@SoLuongNhap int, @NgayXuat nvarchar(30),@SoLuongXuat int, @SoLuongTon int, @SoPhieu nchar(10))
as
update KHO
set TenKho = @TenKho,
NgayNhapKho = CONVERT(varchar,@NgayNhapKho, 103),
SoLuongNhap = @SoLuongNhap,
NgayXuat = CONVERT(varchar,@NgayXuat, 103),
SoLuongXuat = @SoLuongXuat,
SoLuongTon = @SoLuongTon,
SoPhieu = @SoPhieu
where MaKho = @MaKho
-- xoa Kho
go
create proc sp_xoaKho(@ma nchar(10))
as
delete from KHO where MaKho = @ma

--Thêm xóa sửa hóa đơn

-- proc thêm

go
create proc sp_themHoaDon(@MaHD nchar(10) ,@MaNV nchar(10),@MaKH nchar(10),@MaSP nchar(10), @SoLuong int,@NgayLapHD nvarchar(20) )
as
insert into HOADON values(@MaHD ,@MaNV,@MaKH,@MaSP, @SoLuong,CONVERT(varchar,@NgaylapHD, 103) )

-- thực thi


--proc sua hóa đơn
go
create proc sp_capnhapHoaDon(@MaHD nchar(10) ,@MaNV nchar(10),@MaKH nchar(10),@MaSP nchar(10), @SoLuong int,@NgayLapHD nvarchar(20))
as
update HOADON
set MaNV = @MaNV,
MaKH= @MaKH,
MaSP = @MaSP,
SoLuong = @SoLuong,
NgayLapHD = CONVERT(varchar,@NgaylapHD, 103)
where MaHD = @MaHD
-- xoa Hoa Don
go
create proc sp_xoaHoaDon(@ma nchar(10))
as
delete from HOADON where MaHD = @ma

-- Them xoa sửa chi tiết hóa đơn

-- proc thêm

go
create proc sp_themCTHD(@MaHD nchar(10) ,@MaSP nchar(10),@SoLuong int )
as
insert into CHITIETHOADON values(@MaHD  ,@MaSP ,@SoLuong )
-- thực thi



--proc sua chi tiet hóa đơn
go
create proc sp_capnhapCTHD(@MaHD nchar(10) ,@MaSP nchar(10),@SoLuong int )
as
update CHITIETHOADON
set MaSP = @MaSP,
SoLuong= @SoLuong
where MaHD = @MaHD

-- xoa chi tiet Hoa Don
go
create proc sp_xoaCTHD(@ma nchar(10))
as
delete from CHITIETHOADON where MaHD = @ma


-- thêm sữa xóa Khách hàng
-- proc thêm

go
create proc sp_themKH(@MaKH nchar(10) ,@TenKH nvarchar(25),@DiaChi nvarchar(250), @SDT char(11))
as
insert into KHACHHANG values(@MaKH ,@TenKH ,@DiaChi , @SDT)
--thực thi 

--proc cập nhập 
go
create proc sp_capnhapKH(@MaKH nchar(10) ,@TenKH nvarchar(25),@DiaChi nvarchar(250), @SDT char(11))
as
update KHACHHANG
set TenKH = @TenKH,
DiaChi= @DiaChi,
SDT = @SDT
where MaKH= @MaKH
-- xoa Hoa Don
go
create proc sp_xoaKH(@ma nchar(10))
as
delete from KHACHHANG where MaKH = @ma
--lay danh sach loai san pham
go
create proc sp_layDSLSP
as
select * from LOAISANPHAM
--lay danh sach nsx
go
create proc sp_layDSNSX
as
select * from NSX
exec sp_capnhapNSX N'nsx001','sdsfdsf','sdfsdf','098776543'
go
create proc sp_layDSSPDTT
as
select MaSP,TenSP,SoLuong,GiaTien,MaNSX,MaKho from SANPHAM where MaLoaiSP in ('L003')
select * from LOAISANPHAM
-- lay danh sach sp do dung hoc tap
go
create proc sp_layDSSPS
as
select MaSP,TenSP,SoLuong,GiaTien,MaNSX,MaLoaiSach,MaTG,MaKho from SANPHAM where MaLoaiSP in ('L001')
select * from LOAISANPHAM
-- lay danh sach sp do dung trang tri
go
create proc sp_layDSSPDDHT
as
select MaSP,TenSP,SoLuong,GiaTien,MaNSX,MaKho from SANPHAM where MaLoaiSP in ('L002')
drop proc sp_layDSSPDDHT
select * from LOAISANPHAM
--tim kiem nha san xuat
--tim theo ten
go
create proc sp_timKiemNSX(@ten nvarchar(30))
as
select * from NSX where TenNSX like '%' + @ten + '%'
--tim kiem theo ma
go
create proc sp_timKiemNSXMa(@ma nvarchar(30))
as
select * from NSX where MaNSX like '%' + @ma + '%'
--tim kiem khach hang
--tim theo ten
go
create proc sp_timKiemKH(@ten nvarchar(30))
as
select * from KHACHHANG where TenKH like '%' + @ten + '%'
--tim kiem theo ma
go
create proc sp_timKiemKHMa(@ma nvarchar(30))
as
select * from KHACHHANG where MaKH like '%' + @ma + '%'
go
--lay danh sach khach hang
create proc sp_layDSKH
as
select * from KHACHHANG
--tim kiem loai san pham
--tim theo ten
go
create proc sp_timKiemLSP(@ten nvarchar(30))
as
select * from LOAISANPHAM where TenLoaiSP like '%' + @ten + '%'
--tim kiem theo ma
go
create proc sp_timKiemLSPMa(@ma nvarchar(30))
as
select * from LOAISANPHAM where MaLoaiSP like '%' + @ma + '%'
